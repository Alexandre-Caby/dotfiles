# Security Check — Audit de sécurité (OWASP WSTG + ANSSI)

Effectue un audit de sécurité complet sur le code changé ou sur un périmètre donné. Basé sur OWASP WSTG et le référentiel ANSSI d'hygiène informatique.

## Étapes

### 1. Détection du scope
Identifier le type de projet pour appliquer le bon référentiel :
- Web app / API → OWASP WSTG
- Infrastructure → ANSSI 42 rules
- Embedded → Memory safety, physical access
- Tous → Secrets, dépendances, configuration

### 2. Scan automatisé
```bash
# Secrets
grep -rn "password\|secret\|api_key\|token\|private_key\|BEGIN RSA" \
  --include="*.ts" --include="*.py" --include="*.rs" --include="*.go" \
  --include="*.c" --include="*.cpp" . | grep -v node_modules | grep -v .git | grep -v test

# Dépendances
npm audit --audit-level=high 2>/dev/null || \
pip audit 2>/dev/null || \
cargo audit 2>/dev/null || true
```

### 3. OWASP WSTG — Analyse par catégorie

Vérifier chaque catégorie applicable au code modifié :

**CONFIG** — Configuration
- Fichiers sensibles exposés ? (.env, .bak, .sql, .zip)
- Interfaces admin accessibles sans auth ?
- HSTS, CSP, X-Frame-Options, CORS configurés ?
- Stockage cloud (S3, GCS) ouvert ?

**AUTHN** — Authentification
- Credentials sur canal chiffré ?
- Mécanisme de verrouillage (brute force) ?
- Politique de mot de passe robuste ?
- Reset de mot de passe sécurisé ?

**AUTHZ** — Autorisation
- IDOR possible ? (?id=123 → ?id=456)
- Traversée de répertoires ? (../../etc/passwd)
- Escalade de privilèges ? (role=admin)
- Auth vérifiée sur CHAQUE endpoint ?

**SESS** — Sessions
- Cookies : HTTPOnly, Secure, SameSite ?
- Fixation de session ?
- CSRF token présent ?
- Logout détruit la session côté serveur ?

**INPVAL** — Validation des entrées (CRITIQUE)
- XSS réfléchi/stocké/DOM-based ?
- SQL Injection (union, boolean, time-based) ?
- Command injection OS ?
- SSTI (Server-Side Template Injection) ?
- SSRF (Server-Side Request Forgery) ?
- XXE (XML External Entity) ?

**CRYPT** — Cryptographie
- TLS 1.2+ ? Ciphers forts ?
- Données sensibles transmises en clair ?
- Algorithmes de chiffrement faibles (MD5, SHA1 pour passwords) ?

**BUSLOGIC** — Logique métier
- Upload de fichiers malveillants possible ?
- Contournement de workflow (skip d'étapes) ?
- Rate limiting sur les fonctions critiques ?

### 4. Pattern review immédiat

| Pattern | Sévérité | Action |
|---------|----------|--------|
| Secret hardcodé | CRITIQUE | → env var |
| SQL concat string | CRITIQUE | → parameterized query |
| Command injection | CRITIQUE | → safe API / execFile |
| innerHTML = userInput | HAUTE | → textContent / DOMPurify |
| fetch(userUrl) | HAUTE | → URL whitelist |
| Password en clair | CRITIQUE | → bcrypt/argon2 |
| Pas d'auth sur route | CRITIQUE | → middleware auth |
| Pas de rate limit | HAUTE | → rate limiter |
| Pas de CSRF token | HAUTE | → framework CSRF |
| Raw pointer sans check (C) | CRITIQUE | → validate NULL |
| Buffer sans bounds (C) | CRITIQUE | → check lengths |

### 5. Scoring CVSS v3.1

Pour chaque vulnérabilité trouvée, attribuer :
- **CVSS score** (0.0 - 10.0)
- **Exploitabilité** : Triviale / Facile / Modérée / Difficile / Théorique
- **Impact** : Financier / Opérationnel / Image / Légal (1-4 chacun)

## Format de sortie

```
## Audit Sécurité — [date]

### Scope : [Web App | API | Infra | Embedded]
### Référentiel : [OWASP WSTG | ANSSI | Les deux]

### 🔴 CRITIQUE (CVSS ≥ 9.0) — Bloque le déploiement
- [WSTG-XXX-000] [fichier:ligne] Description
  CVSS: X.X | Exploitabilité: [niveau]
  Impact: Fin:[1-4] Ops:[1-4] Img:[1-4] Leg:[1-4]
  Remédiation: [correction spécifique]

### 🟠 HAUTE (CVSS 7.0-8.9)
### 🟡 MOYENNE (CVSS 4.0-6.9)
### 🟢 BASSE (CVSS 0.1-3.9)
### ℹ️ INFO

### Score global : [X/10]
### Couverture WSTG : [X tests applicables vérifiés]
```
