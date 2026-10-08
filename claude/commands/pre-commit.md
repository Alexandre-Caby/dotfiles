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

Each step runs every tool the project declares, and a failing tool stays a
failure. A step that finds no tool reports "none", never a pass.

#### a) Linting
```bash
fail=0
if [ -f Cargo.toml ]; then cargo clippy --workspace --all-targets -- -D warnings || fail=1; fi
if [ -f package.json ] && grep -q '"eslint"' package.json; then npx eslint . --max-warnings 0 || fail=1; fi
if [ -f pyproject.toml ] && grep -q ruff pyproject.toml; then ruff check . || fail=1; fi
echo "LINT_EXIT=$fail"
```

#### b) Formatting
```bash
fail=0
if [ -f Cargo.toml ]; then cargo fmt --all -- --check || fail=1; fi
if [ -f package.json ] && grep -q '"prettier"' package.json; then npx prettier --check . || fail=1; fi
if [ -f pyproject.toml ] && grep -q ruff pyproject.toml; then ruff format --check . || fail=1; fi
echo "FORMAT_EXIT=$fail"
```

#### c) Type checking
```bash
# Rust is type-checked by the clippy build above.
fail=0
if [ -f tsconfig.json ]; then npx tsc --noEmit || fail=1; fi
if [ -f pyproject.toml ] && grep -q mypy pyproject.toml; then python3 -m mypy . || fail=1; fi
echo "TYPES_EXIT=$fail"
```

#### d) Tests
```bash
fail=0; ran=0
if [ -f Cargo.toml ]; then ran=1; cargo test --workspace || fail=1; fi
if [ -f package.json ] && grep -q '"vitest"' package.json; then ran=1; npx vitest run || fail=1
elif [ -f package.json ] && grep -q '"jest"' package.json; then ran=1; npx jest --ci || fail=1; fi
if [ -f pytest.ini ] || { [ -f pyproject.toml ] && grep -q pytest pyproject.toml; }; then ran=1; python3 -m pytest -q || fail=1; fi
echo "TESTS_EXIT=$fail RUNNERS=$ran"
```
A test runner that selects nothing ("running 0 tests") is not a pass. A project
whose sources sit below the root (a `ui/` package) declares its own
`.claude/commands/pre-commit.md`.

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
