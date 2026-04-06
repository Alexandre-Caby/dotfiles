# Debug — Structured diagnosis

Applies a systematic diagnostic method to identify and resolve a bug.

## Protocol

### Phase 1: Reproduce
- Identify the exact steps to reproduce the bug
- Confirm the bug is reliably reproducible
- Isolate the minimal input that triggers the problem

### Phase 2: Isolate
- Identify the file and code area responsible
- Use logs/breakpoints to trace the execution flow
- Narrow the scope: is it the code, a dependency, config, or the environment?

### Phase 3: Diagnose
- Formulate a hypothesis about the root cause
- Verify the hypothesis with a test or targeted modification
- If the hypothesis is wrong, go back to Phase 2

### Phase 4: Fix
- Apply the minimal fix that resolves the problem
- Verify the fix doesn't break anything else (run tests)
- Write a test that would have caught this bug

## Output format

```
## Diagnosis — [short bug description]

**Symptom**: [what happens]
**Expected**: [what should happen]
**Root cause**: [why it happens]
**Fix applied**: [what was changed]
**Test added**: [yes/no — description]
**Regression check**: [tests pass ✅ / fail ❌]
```
