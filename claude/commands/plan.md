# Plan — Feature or task

Creates a detailed implementation plan for the feature or task described by the user.

## Steps

1. **Understand** — Read the relevant existing code before proposing anything
2. **Analyze** — Identify impacted files, dependencies, and risks
3. **Break down** — Create concrete, ordered tasks

## Output format

```
## Plan: [feature title]

### Context
[What exists, what needs to change, why]

### Technical approach
[Architecture choices, patterns to use, justification]

### Tasks
1. [ ] Task 1 — [S/M/L] — [impacted file(s)]
2. [ ] Task 2 — [S/M/L] — [file(s)]
...

### Identified risks
- [Risk] -> [Mitigation]

### What we are NOT doing (scope cut)
- [Feature/detail intentionally excluded and why]
```

## Rules

- Estimation: S = <2h, M = 2-4h, L = 1 day
- Always include a "scope cut" section
- Identify parallelizable vs sequential tasks
- If the task is an L, propose breaking it down into S/M sub-tasks
