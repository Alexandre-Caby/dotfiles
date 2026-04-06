# Cleanup — Dead code + AI slop + simplification cleanup

Analyzes the codebase and safely removes dead code, AI slop, and simplifies code.

## Parameter

$ARGUMENTS = optional scope (e.g., "src/", "file.ts", "all")

If empty, analyze the entire project.

## Steps

### 1. Dead code inventory

```bash
# Node/TypeScript — unused exports, orphan files
npx knip --no-progress 2>/dev/null

# Python — unreachable code
python3 -m vulture . --min-confidence 80 2>/dev/null

# Rust — dead code
cargo clippy -- -W dead_code 2>/dev/null

# Unused imports (multi-language)
grep -rn "^import\|^from.*import\|^use " --include="*.ts" --include="*.py" --include="*.rs" . \
  | grep -v node_modules | grep -v .git
```

### 2. AI slop detection

Scan each file for:

**Useless comments** (remove directly):
- `// increment i` above `i++`
- `// return the result` above `return result`
- `// constructor` above `constructor()`
- `// import X` above an import
- Any comment that repeats the code verbatim

**Filler code** (simplify):
- Wrapper functions that only pass through args
- Classes with a single method -> function
- Interfaces with a single implementation -> remove the interface
- `if (condition) { return true } else { return false }` -> `return condition`
- Unnecessary intermediate variables (`const result = x; return result;` -> `return x`)

**Forgotten console/debug** (remove):
- `console.log` outside config/CLI files
- Debug `print()` in Python
- `dbg!()` in Rust
- Debug `printf` in C

### 3. Safe removal workflow

For each detected item:

1. **Analyze** — verify it is actually dead (no reflection, dynamic import, etc.)
2. **Verify** — ensure tests pass before removal
3. **Remove** — delete the code
4. **Test** — re-run tests after removal
5. **If tests break** -> revert and mark as "false positive"

### 4. Simplification

After cleanup, look for simplifications:

- `for` loops -> `map/filter/reduce` when applicable
- `if/else if` chains -> `switch/match` or lookup table
- Functions > 50 lines -> extract sub-functions
- Files > 300 lines -> split into modules
- Dependencies used for a single function -> implement manually if < 10 lines

### 5. Unused dependencies

```bash
# Node
npx depcheck 2>/dev/null

# Python — check unused imports in requirements
pip list --not-required 2>/dev/null
```

## Output format

```
## 🧹 Cleanup — [date]

### Dead code removed
- [file] Function `foo()` — never called
- [file] Import `bar` — unused
- [file] Variable `temp` — declared, never read

### AI slop cleaned
- [X] paraphrase comments removed
- [X] console.log/print removed
- [X] intermediate variables simplified

### Simplifications applied
- [file] for loop -> array.map()
- [file] if/else chain -> switch

### Dependencies removed
- [package] — used nowhere

### Result
- Lines removed: X
- Files modified: X
- Tests: ✅ all pass after cleanup
```
