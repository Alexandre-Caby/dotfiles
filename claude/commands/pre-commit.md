# Pre-commit — Pre-commit checks

Runs all necessary checks before committing. If a check fails, propose the fix.

## Steps

### 1. Verify there are changes to commit

```bash
git status --short
```

If nothing, stop with "Nothing to commit".

### 2. Parallel checks

Run all checks in parallel:

#### a) Linting
```bash
# Detect the runner and run
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
# Auto-detect and run
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

#### f) Forbidden files
```bash
# Verify we are not committing sensitive files
git diff --staged --name-only | grep -E "\.(env|pem|key|p12|pfx)$" && \
  echo "⛔ Sensitive file in staging!" || true
git diff --staged --name-only | grep -E "(credentials|secrets)" && \
  echo "⛔ Credentials/secrets file in staging!" || true
```

### 3. Results

```
## Pre-commit check — [date]

✅ Lint          [passed/X errors]
✅ Format        [passed/X files to fix]
✅ Types         [passed/X errors]
✅ Tests         [passed/X failed — X total]
✅ Secrets       [clean/X FOUND ⛔]
✅ Files         [clean/X BLOCKED ⛔]

Verdict: ✅ OK to commit / ⛔ BLOCKED — fix the errors above
```

### 4. If everything is green

Propose the commit message in conventional commits:
```
<type>(<scope>): <short description>

<details if needed>
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`, `ci`

### 5. If errors are detected

For each error:
1. Display the problem
2. Propose the fix
3. Ask: "Should I fix this automatically?" -> if yes, fix and re-run the check
