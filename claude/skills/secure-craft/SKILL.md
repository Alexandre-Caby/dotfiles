---
name: secure-craft
description: Comprehensive security-first development intelligence. Use this skill whenever writing, reviewing, or deploying code in any context — web frontends, APIs, infrastructure, or data systems. Embeds the Security Review Loop (with threat modeling) that runs on every piece of code, plus incident response, security testing, and monitoring guidance. Covers the full stack from browser to database, from prevention to detection to response.
---

# Secure Craft

You write code that works AND code that doesn't break when someone tries to break it. Security is not a phase, not a checklist at the end, not someone else's job. It's a **lens** you apply to every decision — from variable naming to architecture.

---

## Core Philosophy

Most security vulnerabilities are not clever zero-days. They're **obvious mistakes that nobody checked for.** An unsanitized input. A secret committed to git. A default password left in place. A debug endpoint left in production. The attacker doesn't need to be smart — they need you to be careless once.

**Five truths:**

1. Every input is hostile until proven otherwise. User input, API responses, file uploads, URL parameters, headers, cookies — ALL of it.
2. The attacker knows your stack. They know your framework's default routes, your ORM's escape behavior, your error message formats. Security through obscurity is not security.
3. Defense in depth means every layer assumes the layer above it has been compromised. Validation on the frontend doesn't replace validation on the backend. A firewall doesn't replace application-level auth.
4. The principle of least privilege applies to everything — users, services, database connections, file permissions, API keys, container processes.
5. Fail secure. When something goes wrong, the system should deny access, not grant it. Errors should hide internals, not expose them.

---

## Threat Modeling — Think Before You Code

For critical features (auth, payments, admin panels, PII handling, public APIs), model the threats BEFORE writing code. The Security Review Loop catches implementation bugs. Threat modeling catches **architectural** vulnerabilities that no amount of code review will find.

### The STRIDE Model (Quick Version)

For each component or feature, ask:

| Threat | Question | Example |
|---|---|---|
| **S**poofing | Can someone pretend to be someone else? | Forged JWT, session hijack, IP spoofing |
| **T**ampering | Can someone modify data they shouldn't? | Unsigned webhook, client-submitted price, MITM on unencrypted channel |
| **R**epudiation | Can someone deny they did something? | Missing audit log, unsigned transactions |
| **I**nformation Disclosure | Can someone see data they shouldn't? | Verbose errors, unencrypted backups, overly broad API responses |
| **D**enial of Service | Can someone make the system unavailable? | No rate limiting, unbounded queries, resource exhaustion |
| **E**levation of Privilege | Can someone gain permissions they shouldn't have? | IDOR, mass assignment, privilege escalation via API |

### When to Threat Model

- **Always**: Auth systems, payment flows, admin panels, file upload handling, anything touching PII or credentials
- **Consider**: New third-party integrations, architectural changes, API surface changes, new public endpoints
- **Skip**: Internal utility scripts, styling changes, dependency version bumps (audit those instead)

### Output Format

A quick threat model doesn't need a formal document. A comment block is enough:

```
Threat Model — Password Reset Flow:
- Spoofing: Token must be single-use, time-limited (30 min), cryptographically random
- Info Disclosure: Don't confirm whether email exists ("If this email is registered, you'll receive a link")
- DoS: Rate limit to 3 requests/hour/email
- Tampering: Token tied to specific user ID, validated server-side
```

---

## The Security Review Loop

Like a design critique engine, this is the **entire point.** Every other section feeds into this. The review loop catches the obvious mistakes before they ship.

### Severity Dial — Matching Rigor to Risk

**Quick / Low risk** — Internal tools, prototypes, personal projects
- Run passes 1-2 (Surface Scan + Secrets Check) only
- Focus on: no hardcoded secrets, basic input validation, no obvious injection

**Standard** — Most production code (default)
- Run all 5 passes
- Full input validation, proper auth, error handling, dependency check

**Critical / High risk** — Auth systems, payment flows, PII handling, public APIs, admin panels
- Run all 5 passes, then run them again
- Threat model first (see above). Full Security Rationale.
- Ask: what's the worst thing that happens if this is compromised?

**Detection:**
- Handles money, credentials, personal data, health info → Critical
- Public-facing API, user-facing auth → Critical
- Internal service, behind VPN → Standard
- Local tool, personal script, prototype → Quick

### The Five Passes

#### Pass 1 — Surface Scan
Read through as an attacker would:
- Where does external data enter? (params, headers, body, files, env vars, DB reads)
- Is every input validated, sanitized, or escaped before use?
- Are there hardcoded values that should be config? (URLs, ports, limits, feature flags)
- Could any error message reveal internals? (stack traces, SQL, file paths, versions)
- Is there commented-out code exposing logic or secrets?

#### Pass 2 — Secrets Check
Hunt for credential exposure:
- Hardcoded passwords, API keys, tokens, connection strings?
- Secrets from env vars or a secrets manager — not committed config files?
- `.env` in `.gitignore`? `.env.example` with placeholders?
- Do logs ever print secrets, tokens, or full request bodies with credentials?
- Are secrets rotatable without full redeploy?

#### Pass 3 — Access Control Review
- Is auth required where it should be? Unprotected routes?
- Is authorization enforced? (Authenticated ≠ authorized. A logged-in user shouldn't access another user's data.)
- Admin/debug endpoints accessible in production?
- DB queries filtered by current user's scope? (IDOR check)
- File operations confined to expected directories? (Path traversal)
- Background jobs running with minimum necessary permissions?

#### Pass 4 — Dependency & Config Check
- Dependencies up to date? Known CVEs?
- Using well-maintained libraries for crypto, auth, sessions — not rolling your own?
- Config secure by default? (Debug off, verbose errors off, HTTPS enforced, secure cookies)
- Default credentials changed? Default ports? Default admin paths?
- Anything running as root that doesn't need to?

#### Pass 5 — Fix
- Don't note issues — **fix them now.** Security TODOs are security holes.
- If the fix is complex, implement the simplest secure version first.
- If unfixable immediately: clear comment with the risk + tracking ticket. Never a silent vuln.
- Re-run passes 1-4 on fixed code.

### Security Rationale

After the loop, share briefly:

```
Security Rationale:
- Risk level: [Quick / Standard / Critical]
- Threat model: [if Critical — key threats identified]
- Key protection: [the ONE most important security measure]
- Input handling: [how external data is validated/sanitized]
- Secrets: [how credentials are managed]
- What I'd attack first: [if I were probing this, where would I start?]
```

---

## Universal Principles

### Input Validation

**Every input is guilty until proven innocent.**

1. **Whitelist, not blacklist**: "Only alphanumeric, 1-100 chars" > "no special characters."
2. **Validate type, length, range, format** before processing.
3. **Validate on the server** — always. Client-side is UX, not security.
4. **Validate at the boundary** — as close to entry as possible.
5. **Encode/escape for the output context** — HTML entities for HTML, parameterized queries for SQL, URL encoding for URLs.

| Mistake | Why Dangerous | Fix |
|---|---|---|
| Blacklisting bad chars | Attackers find what you missed | Whitelist allowed patterns |
| Client-side only | Bypassed trivially | Always validate server-side |
| Trusting "internal" sources | Internal services get compromised | Validate at every boundary |
| No length limits | Memory exhaustion, ReDoS | Explicit max lengths on all inputs |
| Regex for complex formats | ReDoS, misses edge cases | Use established parsers |

### Secrets Management

**Never in code, never in git, never in logs.**

**Hierarchy (best to worst):**
1. Dedicated secrets manager (Vault, AWS Secrets Manager, 1Password SA)
2. Environment variables from secure source (CI/CD secrets, orchestrator secrets)
3. Encrypted config files decrypted at deployment
4. `.env` files on server (if protected, in `.gitignore`, not in webroot)
5. ❌ Hardcoded in source — never. Ever.

**Hygiene:**
- Rotate on schedule and immediately after suspected compromise
- Scope: read-only key for read service, read-write for write service
- `.env.example` with placeholders to document required secrets
- Scan git history: `trufflehog`, `gitleaks`, `git-secrets`
- If a secret leaks: rotate immediately, THEN investigate

### Dependency Security

- **Lock versions**: Use lock files. Floating versions can pull compromised releases.
- **Audit regularly**: `npm audit`, `pip-audit`, `cargo audit`, Dependabot, Snyk. Run in CI.
- **Minimize**: Every dependency is attack surface. Security-critical functions use established libraries. Utility functions — consider writing your own.
- **Monitor advisories**: Subscribe to security feeds for major dependencies.
- **Update promptly**: Known CVE + unpatched = open invitation.

### Error Handling & Logging

**Errors:**
- Never expose internals in responses: stack traces, SQL, file paths, versions → generic message + error code. Details server-side only.
- Fail secure: auth fails → deny. Permission error → deny. Lookup fails → return nothing.
- `catch (e) {}` is a security hole. At minimum, log it. Silent failures hide attacks.
- Same error for wrong username, wrong password, locked account: "Invalid credentials."

**Logging:**
- Never log secrets: passwords, tokens, API keys, session IDs, card numbers.
- DO log security events: failed logins, permission denials, validation failures, rate limit hits, privilege escalations.
- Include context: timestamp, user ID, IP, action attempted, resource, result.
- Structured format (JSON/key-value) — enables analysis and alerting.
- Protect log access — restrict who reads them.

### Least Privilege

Everything gets minimum permissions needed:
- **Users**: Default no access. Grant specific permissions.
- **Services**: Own credentials, scoped to needs.
- **DB connections**: Read-only for reads. Write only where writes happen. Never app queries as admin.
- **File permissions**: No root processes. 600/640, never 777.
- **API keys**: Scoped to specific actions/resources. Time-limited when possible.
- **Containers**: Non-root user. Dropped capabilities. Read-only filesystem.
- **Cloud IAM**: Service-specific roles. Regularly audit unused permissions.

---

## Incident Response

Prevention fails. What happens next determines whether a security event is a contained incident or a catastrophic breach.

### When Something Goes Wrong

**The first 30 minutes matter more than the next 30 days.** Don't investigate first — contain first.

#### Step 1 — Contain (Minutes 0-30)
- **Rotate compromised credentials immediately.** Don't wait to understand the scope. Rotate first, investigate second.
- **Isolate compromised systems.** Network-level if possible (remove from load balancer, firewall rule, kill container). Don't shut down — you might need forensic data.
- **Revoke active sessions** if user accounts are compromised.
- **Disable compromised API keys/tokens.**
- **Preserve evidence**: Don't delete logs, don't wipe the system. Snapshot if possible.

#### Step 2 — Assess (Minutes 30-120)
- **What was compromised?** Credentials? Data? Infrastructure? Determine scope.
- **How did it happen?** Leaked secret, exploited vulnerability, compromised dependency, phishing, misconfiguration?
- **What data was exposed?** PII, credentials, financial data, internal code? This determines notification requirements.
- **Is the attack still active?** Check for persistence: new accounts, cron jobs, modified files, backdoors.
- **Timeline**: When did the compromise start? How long was the window of exposure?

#### Step 3 — Remediate (Hours)
- Fix the root cause (patch vulnerability, remove exposed secret, close misconfiguration).
- Verify the fix by reproducing the attack vector (in a safe environment).
- Scan for lateral movement — did the attacker pivot to other systems?
- Force password resets if user credentials were exposed.
- Deploy additional monitoring for the compromised vector.

#### Step 4 — Communicate (Per Requirements)
- **Internal**: Engineering, security, leadership. What happened, what's the impact, what's fixed.
- **Users**: If user data was exposed, notify promptly. Be honest and specific: what data, what risk, what to do.
- **Regulatory**: GDPR requires notification within 72 hours for personal data breaches. HIPAA has its own timeline. Know your obligations BEFORE an incident.
- **Public**: If appropriate, a clear, non-evasive disclosure. Users respect honesty more than spin.

#### Step 5 — Post-Mortem (Days)
- Blameless post-mortem. What happened, why, how it was detected, how it was resolved, what changes prevent recurrence.
- Document the timeline.
- Assign follow-up actions with owners and deadlines.
- Update monitoring/alerting based on what was missed.
- Update this skill's threat model knowledge based on what was learned.

### Incident Response Preparation

**Before** an incident:
- **Know who to contact**: Security lead, infrastructure lead, legal, communications. Document this somewhere everyone can find it.
- **Have runbooks**: For common scenarios (leaked secret, compromised dependency, unauthorized access, DDoS). Step-by-step actions, not improvisation.
- **Test incident response**: Tabletop exercises or chaos engineering. Practice before the real event.
- **Maintain audit logs**: You can't investigate what you didn't log. Ensure logging covers auth events, admin actions, data access, and configuration changes.

---

## Security Testing

Secure coding practices reduce vulnerabilities. Testing catches what practices miss. Both are necessary.

### Testing Layers

| Layer | What It Catches | When to Run | Tools |
|---|---|---|---|
| **SAST (Static Analysis)** | Code patterns: injection, hardcoded secrets, insecure functions, type confusion | Every commit / PR (in CI) | Semgrep, CodeQL, SonarQube, Bandit (Python), Brakeman (Ruby) |
| **Dependency Scanning** | Known CVEs in dependencies | Every build (in CI) | `npm audit`, `pip-audit`, Dependabot, Snyk, Trivy |
| **Container Scanning** | CVEs in base images, misconfigurations | Every image build (in CI) | Trivy, Docker Scout, Grype, Snyk Container |
| **DAST (Dynamic Analysis)** | Running application vulnerabilities: XSS, injection, misconfig | Staging/pre-production | OWASP ZAP, Burp Suite, Nuclei |
| **Secret Scanning** | Leaked credentials in code/history | Every commit (pre-commit hook + CI) | trufflehog, gitleaks, git-secrets |
| **Penetration Testing** | Business logic flaws, chained vulnerabilities, real-world attack scenarios | Quarterly or before major releases | Manual or professional pentest firms |
| **Fuzzing** | Edge cases, crashes, unexpected behavior from malformed input | Continuous or pre-release | AFL, libFuzzer, Jazzer, or framework-specific fuzzers |

### Integrating Security Testing into CI/CD

**Minimum viable security pipeline:**

```
1. Pre-commit hook → secret scanning (gitleaks)
2. PR/commit → SAST (Semgrep/CodeQL) + dependency audit
3. Build → container image scan (Trivy)
4. Deploy to staging → DAST scan (ZAP baseline)
5. Fail the build on: critical/high CVEs, leaked secrets, confirmed injection patterns
```

**Rules:**
- Security scans must BLOCK merges on critical findings. Not just warn — block.
- False positives happen. Maintain a documented suppression list with justifications. Review suppressions quarterly.
- DAST runs against staging, never production (it sends attack payloads).
- Penetration tests on production are done by professionals with explicit authorization.

### Security Regression Tests

When a vulnerability is found and fixed:
1. Write a test that reproduces the vulnerability.
2. Verify the test fails before the fix and passes after.
3. Keep the test permanently — it ensures the vuln never returns.

This is the security equivalent of a bug regression test, and it's the most underused security practice.

---

## Web / Frontend Security

The browser is **attacker-controlled territory.** Frontend security protects your users from attacks that target the browser through your application.

### XSS (Cross-Site Scripting)

Injection of malicious scripts executed in other users' browsers. OWASP Top 10 perennial.

**Types:**
- **Reflected**: Malicious input in URL reflected in page response without escaping.
- **Stored**: Malicious input saved to DB, executes for every user who views it.
- **DOM-based**: Client-side JS reads attacker-controlled data (URL hash, postMessage, localStorage) and inserts it into DOM unsafely.

**Prevention:**

| Layer | Protection |
|---|---|
| Output encoding | Escape dynamic content for its output context. Modern frameworks auto-escape — unless you bypass. |
| Dangerous methods — AVOID | `innerHTML`, `document.write()`, `dangerouslySetInnerHTML` (React), `v-html` (Vue). If unavoidable, sanitize with DOMPurify. |
| Content Security Policy | CSP headers restrict script execution. See CSP below. |
| HTTPOnly cookies | Prevents JS from reading session cookies, limiting XSS damage. |
| Trusted Types | Browser API preventing DOM XSS. Enforce via CSP: `require-trusted-types-for 'script'`. |

**Framework trap**: React/Vue/Angular escape by default — but `dangerouslySetInnerHTML`, `v-html`, `[innerHTML]` bypass this. Treat every use as a potential XSS vector.

### CSRF (Cross-Site Request Forgery)

Tricks authenticated users into unintended requests. Malicious site triggers actions because the browser sends cookies automatically.

| Method | How |
|---|---|
| CSRF tokens | Unique token per session/form, validated server-side. |
| SameSite cookies | `SameSite=Lax` or `Strict`. Prevents cross-origin cookie sending. |
| Double-submit cookie | Token in both cookie and header. Server verifies match. |
| Origin validation | Check `Origin`/`Referer` header matches your domain. Defense in depth. |

**Rule**: Every state-changing request (POST/PUT/DELETE/PATCH) needs CSRF protection. GET never modifies state.

### Content Security Policy (CSP)

Single most effective XSS defense after output encoding.

```
Content-Security-Policy: 
  default-src 'self';
  script-src 'self';
  style-src 'self' 'unsafe-inline';
  img-src 'self' data: https:;
  connect-src 'self' https://api.yourdomain.com;
  frame-ancestors 'none';
  base-uri 'self';
  form-action 'self';
```

**Key rules:**
- `'unsafe-inline'` for scripts defeats CSP. Use nonces instead: `script-src 'nonce-<random>'`.
- `'unsafe-eval'` allows `eval()`. Avoid if possible.
- Nonces must be cryptographically random and unique per request.
- Test with `Content-Security-Policy-Report-Only` before enforcing.

### CORS

| Rule | Why |
|---|---|
| Never `Access-Control-Allow-Origin: *` with credentials | Any site makes authenticated requests to your API |
| Whitelist specific origins | Not wildcards, not reflected Origin header |
| Never allow `null` origin | Sandboxed iframes and local files send `null` — attackers exploit this |
| Limit allowed methods and exposed headers | Minimize attack surface |

### Cookie Security

All session/auth cookies require:

| Flag | Setting |
|---|---|
| `HttpOnly` | `true` — prevents JS from reading |
| `Secure` | `true` — HTTPS only |
| `SameSite` | `Lax` or `Strict` |
| `Path` | Narrowest applicable path |
| `Domain` | Explicit. Don't use `.yourdomain.com` unless subdomains genuinely need it. |

**Session management:**
- Cryptographically random session IDs, generated server-side.
- Regenerate session ID after login (prevents session fixation).
- Idle timeout (15-30 min for sensitive apps) + absolute timeout (8-24h).
- Invalidate server-side on logout.

### Client-Side Storage

`localStorage`, `sessionStorage`, `IndexedDB` — accessible to any JS on the origin, including XSS payloads.

**Never store**: Session tokens, JWTs, passwords, API keys, PII, payment data.
**Acceptable**: UI preferences, non-sensitive cached data, CSRF tokens.

### postMessage Security

`window.postMessage` enables cross-origin communication between windows/iframes. It's a common XSS vector when misused.

**Receiving messages:**
```javascript
// DANGEROUS — accepts messages from any origin
window.addEventListener('message', (event) => {
  processData(event.data);  // Attacker's iframe can send anything
});

// SAFE — validate origin before processing
window.addEventListener('message', (event) => {
  if (event.origin !== 'https://trusted-app.com') return;
  processData(event.data);  // Only from expected origin
});
```

**Rules:**
- **Always validate `event.origin`** against an explicit allowlist. Never use `*` for the target origin when sending sensitive data.
- **Validate message structure**: Even from trusted origins, validate the data type and shape. Don't pass raw `event.data` into `innerHTML` or `eval`.
- **Don't use `postMessage` for credentials**: Tokens and secrets shouldn't transit through postMessage — use HttpOnly cookies instead.
- **Iframes from third parties**: If you embed third-party iframes, they can `postMessage` to your parent window. Validate rigorously.

### Subdomain Security

Subdomains share more than you think — and abandoned ones are liabilities.

**Subdomain takeover:**
- If `staging.yourdomain.com` pointed to a Heroku/S3/Azure app that no longer exists, an attacker can claim that endpoint and serve content under your domain.
- They inherit cookies scoped to `.yourdomain.com`. They can serve phishing pages that look legitimate.
- **Fix**: Audit DNS records regularly. Remove records for decommissioned services. Don't scope cookies to `.yourdomain.com` unless every subdomain is trusted.

**Cookie scoping risks:**
- A cookie set with `Domain=.yourdomain.com` is sent to ALL subdomains — including compromised or abandoned ones.
- Set cookies on the most specific domain possible. The auth cookie for `app.yourdomain.com` should be scoped to `app.yourdomain.com`, not `.yourdomain.com`.

**Wildcard certificates:**
- A `*.yourdomain.com` certificate is convenient but means any subdomain can present a valid TLS cert. Combined with subdomain takeover, this enables convincing MitM or phishing.
- Consider per-subdomain certificates for critical services.

### Third-Party Scripts

Every external `<script>` runs with full access to your page: DOM, non-HTTPOnly cookies, localStorage, network requests.

- **Subresource Integrity (SRI)**: Hash-check CDN resources. Browser refuses execution if hash mismatches.
- **CSP**: Restrict which domains can serve scripts.
- **Self-host when possible**: You control what executes.
- **Isolate high-risk embeds**: Sandboxed iframes limit third-party access.

---

## API / Backend Security

Your API is the front door to your data. Every endpoint is an invitation for attackers to probe.

### Authentication

| Pattern | Best For | Key Consideration |
|---|---|---|
| Session cookies | Web apps | HttpOnly + Secure + SameSite. Server stores state. |
| JWT | Stateless APIs, microservices | Short-lived (5-15 min). Validate signature always. `alg: none` attack is real. Use RS256/ES256 for public APIs. |
| API keys | Server-to-server | Scope per client. Rate limit. Rotate. Never in frontend. |
| OAuth 2.0 | Third-party login | Authorization Code + PKCE. Never Implicit flow. Validate tokens server-side. |
| mTLS | Zero-trust service mesh | Both sides present certs. Strong but operationally complex. |

**Password handling:**
- Hash with bcrypt or argon2id. Never MD5/SHA-1/SHA-256 alone.
- Work factor: ~250ms per hash.
- Rate limit login: 5-10 attempts/min/account. Lock after 10-20 attempts.
- Generic errors: "Invalid credentials" — never "User not found" vs "Wrong password."

### Authorization

**Authentication ≠ Authorization.** Most API vulns are authorization failures.

**IDOR (Insecure Direct Object Reference)** — #1 API vulnerability:
```
GET /api/users/123/invoices  ← User 123's data
GET /api/users/456/invoices  ← Attacker changes ID — gets user 456's data
```
**Fix**: ALWAYS verify the authenticated user owns or has access to the specific resource. On every request.

**Common failures:**
- Client-submitted `role` or `is_admin` → derive permissions from server session
- Admin endpoints that only check authentication, not authorization → explicit role checks
- Bulk endpoints returning ALL records → filter by user scope server-side

### Injection Prevention

| Type | Prevention |
|---|---|
| SQL injection | Parameterized queries. Always. Never string concatenation. |
| NoSQL injection | Validate types strictly. `{$gt: ""}` in MongoDB queries. Cast to expected types. |
| Command injection | Avoid shell commands with user input. Use parameterized APIs, whitelist values. |
| Template injection (SSTI) | User input as template DATA, never template SOURCE. |
| Path traversal | Allowlist paths. Resolve canonical path, verify within expected directory. |

### Rate Limiting

| Endpoint | Limit | Strategy |
|---|---|---|
| Login / auth | 5-10/min/account | Per-account AND per-IP |
| Password reset | 3-5/hour/account | Per-account. Prevent email enumeration. |
| General API | Per plan/tier | Token bucket or sliding window |
| Expensive operations | Lower than general | Per-user. Queue or reject. |

Return `429 Too Many Requests` with `Retry-After` header.

### Replay Protection & Idempotency

An attacker captures a valid request and resends it. A payment processes twice. A vote counts twice.

**Prevention:**
- **Idempotency keys**: Client sends a unique key with each request (UUID). Server stores the key and returns the cached response on duplicate. Critical for payment and financial APIs.
  ```
  POST /api/charges
  Idempotency-Key: 550e8400-e29b-41d4-a716-446655440000
  ```
- **Timestamp + window**: Reject requests with timestamps older than 5 minutes. Prevents replay of captured requests.
- **Nonces**: Single-use random values. Server tracks used nonces and rejects duplicates.
- **Request signing**: Sign requests with a shared secret + timestamp + nonce. Verify signature, timestamp freshness, and nonce uniqueness.

**When to enforce:**
- Always: payment/financial operations, privilege changes, destructive actions
- Recommended: any state-changing operation on sensitive resources
- Optional: idempotent reads (GET requests are naturally replay-safe)

### File Upload Security

- Validate file type server-side via magic bytes (not Content-Type or extension)
- Limit file size in web server AND application
- Rename to UUID — never use original filename
- Store outside webroot — serve through controller with `Content-Disposition: attachment`
- Scan for malware before making accessible
- Strip metadata (EXIF GPS, device info)

### GraphQL Security

GraphQL has unique attack vectors that REST doesn't share:

**Query depth/complexity attacks:**
```graphql
# Nested query that explodes server resources
{ user { friends { friends { friends { friends { name } } } } } }
```
**Fix**: Enforce maximum query depth (typically 7-10 levels) and query complexity limits. Libraries: `graphql-depth-limit`, `graphql-query-complexity`.

**Introspection in production:**
```graphql
{ __schema { types { name fields { name } } } }
```
Introspection exposes your entire API schema — every type, field, and relationship. **Disable introspection in production.** Enable only in development/staging.

**Batch query abuse:**
```graphql
# Send 1000 queries in one request
[
  { "query": "{ user(id: 1) { email } }" },
  { "query": "{ user(id: 2) { email } }" },
  ...
]
```
**Fix**: Limit batch size (10-20 queries per request). Rate limit by query count, not just request count.

**Field-level authorization:**
In REST, authorization is per-route. In GraphQL, one endpoint serves everything — authorization must be per-field or per-resolver. A `User` type might have `name` (public), `email` (self-only), and `socialSecurityNumber` (admin-only). Each field needs its own access check.

**Recommended GraphQL security stack:**
- Query depth limiting
- Query complexity/cost analysis
- Disabled introspection in production
- Per-field authorization in resolvers
- Batch size limits
- Persistent queries (allowlist of pre-approved queries) for public APIs

### API Design Security

- Specific endpoints > generic query endpoints
- HTTP methods match intent (GET = read, POST = create, etc.)
- Default and maximum pagination limits
- Schema validation on every request body (reject unknown fields — prevents mass assignment)
- Content-Type enforcement (reject unexpected types — prevents XXE)
- Same error structure everywhere, never expose internals

### Webhook Security

- **Verify signatures** from the provider (Stripe, GitHub, etc.)
- **Replay protection**: Reject webhooks older than 5 minutes. Track processed IDs.
- **Process asynchronously**: Queue and process in background. Return 200 quickly.

---

## Infrastructure Security

Your application can have perfect code and still be compromised through infrastructure.

### Docker & Container Security

**Images:**
- Minimal base images: `alpine`, `distroless`, `slim`
- Pin versions: `FROM node:20.11-alpine`, never `latest`
- Multi-stage builds: build stage ≠ run stage. Final image has no compilers, source, or dev deps.
- Scan images: `trivy`, `docker scout`, `grype`
- No secrets in images.

**Runtime:**
- Run as non-root: `USER <non-root-user>` in Dockerfile
- Read-only filesystem: `--read-only`, mount writable volumes only where needed
- Drop capabilities: `cap_drop: ALL`, add back selectively
- Resource limits: `mem_limit`, `cpus`, `pids_limit`
- Never `--privileged`
- Never mount Docker socket unless absolutely necessary

**Compose:**
- Separate networks: frontend proxy doesn't need to reach DB directly
  ```yaml
  networks:
    frontend:
    backend:
  services:
    proxy:
      networks: [frontend]
    app:
      networks: [frontend, backend]
    db:
      networks: [backend]
  ```
- `expose` (container-only) vs `ports` (host-mapped) — only use `ports` for externally-needed services
- Secrets via `env_file` or Docker secrets, never hardcoded

### CI/CD Pipeline Security

- Use platform secret storage (GitHub Actions Secrets, GitLab CI variables)
- Mask secrets in logs — verify custom scripts don't print them
- Scope secrets: production keys not available to fork PR builds
- Pin action versions (commit SHA > tags)
- Security scans in CI: dependency audit, container scan, SAST, secret detection
- Separate build and deploy pipelines with different credentials
- Protected main branch: PR reviews, status checks required
- Audit pipeline config changes

### Network Security

- **Don't expose internal services**: DB ports, Redis, message queues — never internet-reachable
- **Bind to localhost**: Services needing only local access listen on `127.0.0.1`, not `0.0.0.0`
- **Firewall**: Default deny inbound. Allow only required ports. Block unnecessary outbound.
- **Segment**: Public tier → app tier → data tier. Each only talks to its neighbor.

### TLS Configuration

- TLS 1.2+ everywhere, including internal traffic
- AEAD ciphers (AES-GCM, ChaCha20-Poly1305). Disable CBC, DES, RC4, MD5.
- HSTS: `Strict-Transport-Security: max-age=63072000; includeSubDomains; preload`
- Automated certificates (Let's Encrypt). Manual renewal = risk.

### SSH Hardening

- Key-based auth only. Disable passwords.
- `PermitRootLogin no`
- Fail2ban for brute force blocking
- Restrict SSH to admin IPs or VPN

### Server Hardening

- Remove unnecessary packages and services
- Automatic security updates
- Each service runs as its own non-root user
- File permissions: 640/750, never 777
- Mount options: `noexec`, `nosuid` on `/tmp` and upload dirs

### Cloud Security

- **IAM**: Per-service roles with minimum permissions. No long-lived static keys. MFA for humans. Audit quarterly.
- **Storage**: Private by default. Pre-signed URLs for temporary access. Encryption at rest. Block public access at account level.
- **Networking**: DB/backend in private subnets. Security groups as allowlists. VPN/bastion for admin access.

---

## Monitoring, Detection & Alerting

Hardening without monitoring is half the picture. You need to know when something is being probed, breached, or abused — ideally before the attacker achieves their goal.

### What to Monitor

| Signal | What It Indicates | Alert Threshold |
|---|---|---|
| Failed login spikes | Brute force / credential stuffing | >10 failures/min for one account, or >50/min system-wide |
| 401/403 response spikes | Probing for unauthorized access | Unusual increase over baseline |
| Rate limit hits | Scraping, enumeration, abuse | Any sustained rate limit triggering |
| New admin accounts created | Potential privilege escalation | Any — should be manually triggered and rare |
| Unusual data access patterns | Data exfiltration, insider threat | Large export queries, off-hours access to sensitive data |
| Configuration changes | Unauthorized infrastructure modification | Any change outside of deployment pipeline |
| Dependency/image vulnerability alerts | New CVE in your stack | Critical/High severity |
| SSH login from new IP | Potential unauthorized access | Any IP not in known admin list |
| Container escape indicators | Privilege escalation, breakout attempt | Process running as root that shouldn't be, unexpected mounts |
| DNS changes | Subdomain takeover setup | Any change to production DNS records |

### Monitoring Architecture

**Minimum viable monitoring stack:**
- **Log aggregation**: Centralize logs from all services (ELK, Loki, CloudWatch Logs, Datadog). You can't search what's scattered across 20 containers.
- **Metrics**: Track error rates, latency, request volume by endpoint. Anomalies in these are often the first sign of attack.
- **Alerting**: PagerDuty, Opsgenie, or simple webhook alerts. Critical security events page someone. Don't just log — notify.
- **Uptime monitoring**: External health checks that detect outages (including DDoS).

**Advanced (for larger systems):**
- **SIEM** (Security Information and Event Management): Correlate events across sources. Detect patterns that single-source monitoring misses.
- **IDS/IPS** (Intrusion Detection/Prevention): Network-level attack detection. Snort, Suricata, or cloud-native equivalents.
- **Runtime security**: Falco (container runtime), AWS GuardDuty (cloud), detect anomalous behavior inside running systems.

### Alerting Rules

- **Critical (page immediately)**: Compromised credentials, unauthorized admin access, data exfiltration indicators, infrastructure config changes outside deployments.
- **High (alert within 1 hour)**: Sustained brute force, new critical CVE in running deps, unusual spike in 5xx errors, rate limit exhaustion.
- **Medium (review daily)**: Failed login trends, dependency vulnerability warnings, certificate expiration within 30 days.
- **Low (review weekly)**: Minor dependency updates, configuration drift, access pattern changes.

**Alert fatigue is real.** Too many alerts = all alerts ignored. Tune thresholds. Suppress known false positives with documented justifications. Every alert should be actionable.

---

## Data Security

Data is what attackers want. Everything else exists to protect it.

### Encryption at Rest

| Level | Protects Against | Implementation |
|---|---|---|
| Full disk encryption | Physical theft, improper disposal | OS-level or cloud provider (always enable — it's a checkbox) |
| Database TDE | File access, backup theft | Built into PostgreSQL, MySQL, MongoDB |
| Application-level | DB compromise, insider threats, rogue DBA | Encrypt sensitive fields before storing. App holds keys, not DB. |

**Use all three layers for sensitive data. FDE/cloud encryption at minimum for everything.**

### Encryption in Transit

- TLS 1.2+ for all traffic — external AND internal
- Database connections over TLS (`sslmode=require`)
- Backups transferred over encrypted channels

### Cryptographic Choices

| Purpose | Use | Avoid |
|---|---|---|
| Symmetric encryption | AES-256-GCM, ChaCha20-Poly1305 | DES, 3DES, AES-ECB, RC4 |
| Password hashing | bcrypt, argon2id | MD5, SHA-1, SHA-256 alone |
| Signatures | Ed25519, ECDSA P-256 | RSA-1024, DSA |
| Random numbers | OS CSPRNG (`/dev/urandom`, `crypto.randomBytes`) | `Math.random()`, timestamp seeds |

**Rules**: Never ECB mode. Always authenticated encryption. Never same key for different purposes (derive with HKDF). Never roll your own crypto.

### Database Security

- TLS on all connections
- Per-service database users with scoped permissions (read-only for reads, etc.)
- No app queries as admin — admin only for migrations
- Row-level security (PostgreSQL RLS) for defense in depth against IDOR
- Parameterized queries — always. Even in ORM raw query methods.
- Default `LIMIT` on all queries — unbounded `SELECT *` is a DoS vector
- Audit logging: who queried what, when

### PII Handling

**Data minimization**: Collect only what's needed. Anonymize for analytics. Retention limits — delete when expired. "Might need later" is not a policy.

| Where PII Appears | Mitigation |
|---|---|
| Database | Application-level encryption for sensitive fields |
| Logs | Never log passwords, tokens, SSNs, card numbers. Mask/truncate PII. |
| Error messages | PII never in user-facing errors |
| Backups | Encrypted, access-controlled, retention policies |
| Caches | TTL on cached PII. Encrypt sensitive cached data. Clear on user deletion. |
| Third-party services | DPAs. Minimize data shared. Audit access. |
| Email/notifications | Minimize PII. Never send passwords or full account numbers via email. |

**Compliance awareness** (consult legal for specifics): GDPR (EU, 72-hour breach notification), CCPA (California, right to delete), HIPAA (US health data), PCI DSS (payment data).

### Key Management

- Keys and data stored separately. Always.
- Use KMS (AWS KMS, GCP Cloud KMS, Vault) for hardware-backed storage, rotation, and audit.
- Key hierarchy: master key (KMS) → data encryption keys (envelope encryption). Rotate DEKs without re-encrypting all data.
- Rotate on schedule + immediately on suspected compromise.
- Destroy decommissioned keys securely and irreversibly.

### Backup Security

- Encrypt at rest and in transit
- **Test restores** — quarterly at minimum. Untested backup = no backup.
- Retention policies: daily 7d, weekly 4w, monthly 12m. Delete expired.
- Off-site copy (different region/provider)
- Restrict backup access as strictly as production DB access
- Monitor backup jobs — alert on failures

**3-2-1 rule**: 3 copies, 2 different storage systems, 1 off-site.

### Data Migration Security

When data moves between systems (DB migration, cloud migration, service split), it's at its most exposed.

**Risks during migration:**
- Temporary files with unencrypted data on disk
- Migration scripts with embedded credentials
- Unencrypted transit between old and new systems
- Expanded access permissions "to make migration work" that never get reverted
- Old system retained "just in case" with stale security (unpatched, unmonitored)

**Migration security checklist:**
- [ ] Data transferred over encrypted channels (TLS, encrypted tunnel, encrypted export files)
- [ ] Migration credentials are temporary and scoped — created for migration, revoked after
- [ ] No credentials hardcoded in migration scripts — use env vars or secrets manager
- [ ] Temporary data files encrypted or on encrypted storage, deleted after migration
- [ ] Access permissions on new system verified (least privilege, not broader than old system)
- [ ] Old system decommissioned on schedule — data wiped, DNS records removed, credentials rotated
- [ ] Verification that migrated data is complete and correct before old system shutdown
- [ ] Audit log of migration actions: who moved what, when, to where

---

## Security Anti-Patterns — Full Stack

| Anti-Pattern | What to Do Instead |
|---|---|
| `// TODO: add auth later` | Add auth now. Open ticket for hardening. |
| Rolling your own crypto | Use bcrypt, argon2, libsodium, framework crypto |
| `catch (e) {}` | Log error, return generic message, alert if suspicious |
| String concatenation for queries | Parameterized queries. Always. |
| Storing passwords in plaintext | bcrypt or argon2id hash |
| `*` permissions / admin everywhere | Least privilege. Scoped permissions per service. |
| Trusting the client | Server-side validation and authorization for everything |
| Long-lived tokens that never expire | Short-lived + refresh. Revocation capability. |
| `dangerouslySetInnerHTML` without sanitization | DOMPurify or restructure to avoid raw HTML |
| JWT in localStorage | HttpOnly cookies |
| `Access-Control-Allow-Origin: *` with credentials | Explicit origin allowlist |
| Running containers as root | Non-root user, dropped capabilities |
| Secrets in docker-compose or Dockerfile | Runtime injection via env vars or secrets manager |
| Database port exposed to internet | Bind to localhost or internal network only |
| `chmod 777` | Restrictive permissions (640, 750) |
| No rate limiting on auth endpoints | Rate limit by account AND by IP |
| Accepting `role`/`is_admin` from client | Derive permissions from server session |
| No monitoring or alerting | Centralized logs, anomaly alerts, security event tracking |
| "We're too small to be a target" | Automated scanners don't care about company size |
| Keeping data "just in case" | Retention policies. Delete expired data. Minimize collection. |

---

## Remember

- **Every input is hostile.** Validate, sanitize, encode. At every boundary.
- **Threat model before you code** — for critical features. STRIDE in a comment block takes 5 minutes and catches architectural flaws.
- **The review loop is the skill.** Run it on every piece of code. Severity dial tells you how deep.
- **Secrets never touch code or git.** Env vars minimum. Secrets manager for production.
- **Fail secure.** When in doubt, deny. When errors happen, hide internals.
- **Least privilege everything.** Users, services, DB connections, files, API keys, containers.
- **Dependencies are attack surface.** Lock, audit, minimize, update.
- **Test security, don't just build it.** SAST, DAST, dependency scanning, secret scanning — in CI.
- **Monitor and detect.** Prevention without detection is half the picture. Log, alert, investigate.
- **When breached, contain first.** Rotate credentials immediately. Investigate second.
- **Data you don't store can't be breached.** Collect minimum, retain shortest, delete when done.
- **Show your thinking.** Share the Security Rationale. Make security decisions visible.
