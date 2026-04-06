# Security Check — Security audit (OWASP WSTG + ANSSI)

Performs a comprehensive security audit on changed code or a given scope. Based on OWASP WSTG and the ANSSI IT hygiene framework.

## Steps

### 1. Scope detection
Identify the project type to apply the right framework:
- Web app / API -> OWASP WSTG
- Infrastructure -> ANSSI 42 rules
- Embedded -> Memory safety, physical access
- All -> Secrets, dependencies, configuration

### 2. Automated scan
```bash
# Secrets
grep -rn "password\|secret\|api_key\|token\|private_key\|BEGIN RSA" \
  --include="*.ts" --include="*.py" --include="*.rs" --include="*.go" \
  --include="*.c" --include="*.cpp" . | grep -v node_modules | grep -v .git | grep -v test

# Dependencies
npm audit --audit-level=high 2>/dev/null || \
pip audit 2>/dev/null || \
cargo audit 2>/dev/null || true
```

### 3. OWASP WSTG — Category analysis

Check each category applicable to the modified code:

**CONFIG** — Configuration
- Sensitive files exposed? (.env, .bak, .sql, .zip)
- Admin interfaces accessible without auth?
- HSTS, CSP, X-Frame-Options, CORS configured?
- Cloud storage (S3, GCS) open?

**AUTHN** — Authentication
- Credentials over encrypted channel?
- Lockout mechanism (brute force)?
- Strong password policy?
- Secure password reset?

**AUTHZ** — Authorization
- IDOR possible? (?id=123 -> ?id=456)
- Directory traversal? (../../etc/passwd)
- Privilege escalation? (role=admin)
- Auth checked on EVERY endpoint?

**SESS** — Sessions
- Cookies: HTTPOnly, Secure, SameSite?
- Session fixation?
- CSRF token present?
- Logout destroys session server-side?

**INPVAL** — Input validation (CRITICAL)
- Reflected/stored/DOM-based XSS?
- SQL Injection (union, boolean, time-based)?
- OS command injection?
- SSTI (Server-Side Template Injection)?
- SSRF (Server-Side Request Forgery)?
- XXE (XML External Entity)?

**CRYPT** — Cryptography
- TLS 1.2+? Strong ciphers?
- Sensitive data transmitted in cleartext?
- Weak encryption algorithms (MD5, SHA1 for passwords)?

**BUSLOGIC** — Business logic
- Malicious file upload possible?
- Workflow bypass (skipping steps)?
- Rate limiting on critical functions?

### 4. Immediate pattern review

| Pattern | Severity | Action |
|---------|----------|--------|
| Hardcoded secret | CRITICAL | -> env var |
| SQL concat string | CRITICAL | -> parameterized query |
| Command injection | CRITICAL | -> safe API / execFile |
| innerHTML = userInput | HIGH | -> textContent / DOMPurify |
| fetch(userUrl) | HIGH | -> URL whitelist |
| Plaintext password | CRITICAL | -> bcrypt/argon2 |
| No auth on route | CRITICAL | -> auth middleware |
| No rate limit | HIGH | -> rate limiter |
| No CSRF token | HIGH | -> framework CSRF |
| Raw pointer without check (C) | CRITICAL | -> validate NULL |
| Buffer without bounds (C) | CRITICAL | -> check lengths |

### 5. CVSS v3.1 scoring

For each vulnerability found, assign:
- **CVSS score** (0.0 - 10.0)
- **Exploitability**: Trivial / Easy / Moderate / Difficult / Theoretical
- **Impact**: Financial / Operational / Reputational / Legal (1-4 each)

## Output format

```
## Security Audit — [date]

### Scope: [Web App | API | Infra | Embedded]
### Framework: [OWASP WSTG | ANSSI | Both]

### 🔴 CRITICAL (CVSS >= 9.0) — Blocks deployment
- [WSTG-XXX-000] [file:line] Description
  CVSS: X.X | Exploitability: [level]
  Impact: Fin:[1-4] Ops:[1-4] Rep:[1-4] Leg:[1-4]
  Remediation: [specific fix]

### 🟠 HIGH (CVSS 7.0-8.9)
### 🟡 MEDIUM (CVSS 4.0-6.9)
### 🟢 LOW (CVSS 0.1-3.9)
### ℹ️ INFO

### Overall score: [X/10]
### WSTG coverage: [X applicable tests verified]
```
