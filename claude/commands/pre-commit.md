# Pre-commit — Vérifications avant commit

Exécute toutes les vérifications nécessaires avant de commiter. Si un check échoue, proposer le fix.

## Étapes

### 1. Vérifier qu'il y a des changements à commiter

```bash
git status --short
```

Si rien, arrêter avec "Rien à commiter".

### 2. Checks parallèles

Lancer tous les checks en parallèle :

#### a) Linting
```bash
# Détecter le runner et lancer
npx eslint . --ext .ts,.tsx --max-warnings 0 2>/dev/null || \
ruff check . 2>/dev/null || \
cargo clippy -- -D warnings 2>/dev/null || \
true
```

#### b) Formatting
```bash
npx prettier --check "**/*.{ts,tsx,js,jsx,json,css}" 2>/dev/null || \
ruff format --check . 2>/dev/null || \
cargo fmt --check 2>/dev/null || \
true
```

#### c) Type checking
```bash
npx tsc --noEmit 2>/dev/null || \
python3 -m mypy . 2>/dev/null || \
true
```

#### d) Tests
```bash
# Auto-detect et run
npx vitest run --reporter=verbose 2>/dev/null || \
npx jest --ci 2>/dev/null || \
python3 -m pytest -x -q 2>/dev/null || \
cargo test 2>/dev/null || \
true
```

#### e) Secrets scan
```bash
grep -rn "password\s*=\s*['\"]" --include="*.ts" --include="*.py" --include="*.rs" . \
  | grep -v node_modules | grep -v .git | grep -v test | grep -v example
grep -rn "AKIA[A-Z0-9]" . | grep -v .git  # AWS keys
grep -rn "sk-[a-zA-Z0-9]" . | grep -v .git | grep -v test  # API keys
```

#### f) Fichiers interdits
```bash
# Vérifier qu'on ne commite pas des fichiers sensibles
git diff --staged --name-only | grep -E "\.(env|pem|key|p12|pfx)$" && \
  echo "⛔ Fichier sensible dans le staging !" || true
git diff --staged --name-only | grep -E "(credentials|secrets)" && \
  echo "⛔ Fichier credentials/secrets dans le staging !" || true
```

### 3. Résultats

```
## Pre-commit check — [date]

✅ Lint          [passed/X errors]
✅ Format        [passed/X files to fix]
✅ Types         [passed/X errors]
✅ Tests         [passed/X failed — X total]
✅ Secrets       [clean/X TROUVÉS ⛔]
✅ Fichiers      [clean/X BLOQUÉS ⛔]

Verdict : ✅ OK to commit / ⛔ BLOQUÉ — corriger les erreurs ci-dessus
```

### 4. Si tout est vert

Proposer le message de commit en conventional commits :
```
<type>(<scope>): <description courte>

<détails si nécessaire>
```

Types : `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`, `ci`

### 5. Si des erreurs sont détectées

Pour chaque erreur :
1. Afficher le problème
2. Proposer le fix
3. Demander : "Je corrige automatiquement ?" → si oui, corriger et re-run le check
