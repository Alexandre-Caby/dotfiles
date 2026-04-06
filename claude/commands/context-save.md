# Context Save — Save session state

Generates or updates the `CONTEXT.md` file at the project root with the current session state.

## Steps

1. Read the existing `CONTEXT.md` if there is one
2. Run `git status` and `git log --oneline -10` to get the git state
3. Synthesize the current session

## CONTEXT.md format

```markdown
# Context — [project name]
> Last updated: [ISO date]

## Status
[In progress / Blocked / Ready for review / ...]

## Active work
[What is currently being worked on — 1-3 sentences max]

## Progress
- [x] What is done
- [ ] What remains

## Decisions made
- [Decision] — [Short justification]

## Known blockers
- [Blocker] — [Impact]

## Accepted technical debt
- [Shortcut taken] — [When to fix it]

## Key files modified
- `path/to/file` — [what changed]

## Git state
- Branch: [name]
- Last commit: [short hash] [message]
- Uncommitted files: [list or "none"]

## Next session: first 3 actions
1. [Concrete, executable action]
2. [Concrete action]
3. [Concrete action]
```

## Rules

- Be concise — each section should fit in a few lines
- "Next session" must be immediately executable, not vague
- If CONTEXT.md contradicts the code, the code is right
- Do not include code in CONTEXT.md, only references to files
