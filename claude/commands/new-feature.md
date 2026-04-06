# New Feature — Full orchestrated cycle with agents and teams

Orchestrates the complete feature development cycle by automatically using the right agents and teams based on context.

## Parameter

$ARGUMENTS = feature description (e.g., "JWT auth for the API", "BCI signal parser in Rust")

## Phase 1 — Analysis and plan

### 1a. Preliminary research (if unknown technology)

If the feature involves a technology, lib, or pattern not yet used in the project:
- **Agent `docs-fetcher`** -> live documentation via Context7
- **Agent `web-search`** -> state of the art, comparisons, best practices
- **Team `research-team`** -> if multiple technologies to evaluate

### 1b. Stack choice (if ambiguous)

If the language or framework is not obvious:
- **Agent `language-advisor`** -> analyze constraints and recommend
- NEVER assume — always justify the choice

### 1c. Structured plan

Use **agent `feature-planner`** to produce:

| # | Task | Size | Files | Planned tests |
|---|------|------|-------|---------------|
| 1 | ... | S/M/L | ... | ... |

Plus:
- Identified risks and mitigations
- Possible scope cuts (if tight deadline)
- New dependencies to justify

### 1d. Architecture validation (if > 3 files or structural change)

- **Agent `architect`** -> review coupling, SOLID, scalability, red flags
- **Agent `api-designer`** -> if endpoints/routes are involved

**-> STOP: Present the plan and wait for validation before continuing.**

## Phase 2 — TDD Implementation

### Automatic dispatch

- **If feature >= 3 files or front + back** -> delegate to **team `feature-dev-team`**
- **If simple feature (1-2 files)** -> direct execution with **agent `tdd-guide`**

### Cycle for each task

1. **Agent `tdd-guide`** supervises the Red-Green-Refactor cycle:
   - Write the failing test (RED)
   - Write the minimal code that passes (GREEN)
   - Refactor without breaking tests
   - Verify: `vitest run` / `pytest` / `cargo test` / `ctest`

2. **Agent `test-writer`** completes tests if coverage < 80%:
   - Edge cases: null, empty, overflow, network errors
   - Integration tests if API/DB involved

3. If new dependency added -> **agent `dependency-auditor`** checks for CVE

Strict rules:
- **Never code without tests**
- One task at a time, in plan order
- If DB migration needed -> **agent `migration-writer`**
- Conventional commits: `feat(scope): description`

## Phase 3 — Review and audit

### Automatic review

- **Agent `security-reviewer`** -> OWASP WSTG on changed code
- **Agent `refactor-cleaner`** -> AI slop, dead code, simplifications
- **Agent `perf-auditor`** -> if endpoints, DB queries, or heavy processing

### Checklist

- [ ] All tests pass
- [ ] Coverage >= 80% on new code
- [ ] No regressions
- [ ] No hardcoded secrets
- [ ] No AI slop (paraphrase comments, over-abstraction)
- [ ] Doxygen documentation on new public functions
- [ ] No unjustified `any` / `# type: ignore` / `unsafe`

## Phase 4 — Commit

- **Agent `git-workflow`** -> conventional commit message, appropriate scope
- **Agent `env-auditor`** -> verify .env / .env.example consistency if modified

## Output format

```
## ✅ Feature completed — [name]

### Agents used
- [agent-1] — [what it did]
- [agent-2] — [what it did]
- Team [team-name] (if used)

### Summary
[1-2 sentences]

### Files created/modified
- [file] — [description]

### Tests
- X tests written / X assertions
- Coverage: X%

### Review
- Quality: X/10 | Security: X/10
- Issues fixed: X

### Commits
- feat(scope): ...
- test(scope): ...
```
