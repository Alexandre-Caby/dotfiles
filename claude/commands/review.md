# Code Review — Since last commit

Analyzes changes since the last commit and provides a structured code review.

## Steps

1. Run `git diff HEAD~1` to see the changes
2. If no previous commit, use `git diff --staged` then `git diff`

## Review checklist

For each modified file, evaluate:

### Correctness
- Is business logic correct?
- Are edge cases handled?
- Are errors propagated correctly?

### Security
- Are inputs validated?
- No hardcoded secrets?
- No possible SQL/XSS/command injection?

### Performance
- N+1 queries?
- Unnecessarily repeated computations?
- Memory: large objects not freed?

### Maintainability
- Clear and consistent naming?
- Doxygen documentation on new public functions?
- Duplicated code?
- Tests covering the changes?

## Output format

```
## Review — [date]

### Summary
[1-2 sentences about the nature of the changes]

### 🔴 Critical (blocks merge)
- [file:line] Problem description

### 🟡 Important (should fix)
- [file:line] Description

### 🟢 Suggestions (nice to have)
- [file:line] Description

### ✅ Positive points
- What is well done
```
