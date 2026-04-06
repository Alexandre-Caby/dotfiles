# Audit — Full quality + security + cleanliness audit

Runs an exhaustive project audit in 4 phases. Combines review, security, and cleanup in a single pass.

## Parameter

$ARGUMENTS = optional scope (e.g., "src/", "since last commit", "all")

If empty, audit changes since the last commit. If "all", audit the entire project.

## Phase 1 — Automated scan

Run in parallel:

```bash
# Exposed secrets
grep -rn "password\|secret\|api_key\|token\|private_key\|BEGIN RSA\|BEGIN OPENSSH" \
  --include="*.ts" --include="*.py" --include="*.rs" --include="*.go" \
  --include="*.c" --include="*.cpp" --include="*.h" . \
  | grep -v node_modules | grep -v .git | grep -v test | grep -v "\.example"

# Vulnerable dependencies
npm audit --audit-level=moderate 2>/dev/null; \
pip audit 2>/dev/null; \
cargo audit 2>/dev/null; \
true

# Dead code
npx knip --no-progress 2>/dev/null || \
python3 -m vulture . 2>/dev/null || \
true

# Forgotten TODO/FIXME/HACK
grep -rn "TODO\|FIXME\|HACK\|XXX\|TEMP\|WORKAROUND" \
  --include="*.ts" --include="*.py" --include="*.rs" --include="*.go" \
  --include="*.c" --include="*.cpp" . \
  | grep -v node_modules | grep -v .git
```

## Phase 2 — Code quality review

For each file in scope:

### Correctness
- Is business logic correct?
- Are edge cases handled (null, empty, overflow, concurrency)?
- Are errors propagated correctly (no empty catch)?
- Are types correct (no `any` in TS, no `# type: ignore` in Python)?

### Performance
- N+1 queries?
- Unnecessarily repeated computations in loops?
- Memory: leaks, large objects not freed?
- Excessive algorithmic complexity?

### Maintainability
- Clear naming (no `data`, `temp`, `stuff`, `x`)?
- Functions < 50 lines, single responsibility?
- Doxygen documentation on public functions?
- DRY respected (no copy-paste)?

### Tests
- Coverage: does every public function have a test?
- Are tests meaningful (not just "it doesn't crash")?
- Are edge cases tested?
- Minimal mocks (no mocks that always return true)?

## Phase 3 — Security (OWASP WSTG + ANSSI)

Apply the same framework as `/user:security-check`:
- CONFIG, AUTHN, AUTHZ, SESS, INPVAL, CRYPT, BUSLOGIC
- Pattern review (17 critical patterns)
- CVSS v3.1 scoring per vulnerability

## Phase 4 — AI slop & clean code

Detect signs of generated code without review:

### AI Slop checklist
- [ ] Comments that paraphrase the code (`// increment i by 1`)
- [ ] Over-abstraction (3 files for a 5-line helper)
- [ ] Filler words in docstrings ("This function basically...")
- [ ] Forgotten console.log / debug prints
- [ ] Dead code (never-called functions, unused imports)
- [ ] Variables declared but never used
- [ ] Try-catch with empty catch or `// TODO: handle error`
- [ ] `any` / `object` / `dict` types without documented reason
- [ ] Dependencies imported but unused in package.json/Cargo.toml
- [ ] README.md with unpersonalized template content

### Simplification
- Code that can be reduced (map/filter vs manual loop)?
- Unnecessary abstractions (interface with a single implementation)?
- Duplicated config files?

## Output format

```
# 🔍 Full audit — [date]

## Scope: [description]
## Duration: [time]

## Executive summary
- Quality score: [X/10]
- Security score: [X/10]
- Cleanliness score: [X/10]
- **Overall score: [X/10]**

## 🔴 Blockers (must fix before merge)
1. [SEC] [file:line] Description — CVSS X.X
2. [BUG] [file:line] Description
3. [TEST] No tests for [module]

## 🟠 Important (fix soon)
1. [PERF] [file:line] Description
2. [SLOP] [file:line] Description

## 🟡 Improvements (next iteration)
1. [CLEAN] Description
2. [DOC] Description

## 🟢 Positive points
- [what is well done]

## Metrics
- Files analyzed: X
- Vulnerabilities: X critical / X high / X medium
- Dead code detected: X functions / X imports
- AI slop detected: X occurrences
- Estimated test coverage: X%
```
