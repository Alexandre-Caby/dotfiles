# Test — Run and analyze tests

Runs the project test suite and analyzes the results.

## Automatic runner detection

1. Check for config files and run:
   - `package.json` with test script -> `npm test` or `pnpm test`
   - `vitest.config.*` -> `npx vitest run`
   - `jest.config.*` -> `npx jest`
   - `pytest.ini` / `pyproject.toml` [tool.pytest] -> `pytest -v`
   - `Cargo.toml` -> `cargo test`
   - `go.mod` -> `go test ./...`

2. If multiple runners possible, ask the user

## Result analysis

For each failing test:

```
### ❌ [test name]
**File**: [path:line]
**Error**: [concise error message]
**Probable cause**: [diagnosis]
**Suggested fix**: [proposed correction]
```

## Final summary

```
✅ [X] passed | ❌ [Y] failed | ⏭ [Z] skipped
Coverage: [X]% (if available)
```
