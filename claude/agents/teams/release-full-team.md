---
model: haiku
description: |
  Full release pipeline: security audit + test coverage check -> changelog +
  version bump + git tag. One command for a clean, traceable release.
tools:
  - Task
  - Read
  - Bash
---

## Input

Required: `bump_type` -- one of `patch`, `minor`, `major`
Optional: `skip_audit` -- set to true only if audit was run in the last 24h

## Phase 1 -- Parallel pre-release checks

Spawn simultaneously:

**Agent 1 -- dependency-auditor**
```
Full security audit for this project.
Report: any CRITICAL or HIGH CVEs that block release, list of outdated deps.
Go/no-go: BLOCK if any CRITICAL CVE exists.
```

**Agent 2 -- test coverage check**
```bash
npx vitest run --coverage 2>/dev/null || npm test -- --coverage  # Node.js/TS
pytest --tb=short -q 2>/dev/null                                  # Python
cargo test 2>/dev/null                                            # Rust
go test ./... 2>/dev/null                                         # Go
```
Report: test pass/fail count, any failures.
Go/no-go: BLOCK if any test fails.

### Phase 1 gate

- ALL tests pass? -> continue
- Zero CRITICAL CVEs? -> continue
- Otherwise: STOP and report blockers. Do not proceed to Phase 2.

## Phase 2 -- Release (sequential)

Only after Phase 1 passes:

**Step 1 -- env-auditor (quick)**
```
Quick check: is .env.example up to date?
Report: any undocumented vars added since last release.
(Non-blocking -- only warn, don't stop)
```

**Step 2 -- git-workflow: changelog**
```
Generate CHANGELOG entry for [bump_type] release.
Include: all commits since last tag, grouped by type (feat/fix/chore/docs).
Format: Keep a Changelog (https://keepachangelog.com)
```

**Step 3 -- release-manager**
```
Execute full release:
- Bump version ([bump_type])
- Update CHANGELOG with generated entry
- Commit: "chore(release): vX.Y.Z"
- Tag: vX.Y.Z
- (if applicable) Build and tag Docker image
```

## Output

```markdown
## Release Report -- v[X.Y.Z] -- [date]

### Pre-release checks
- Dependencies: OK / N warnings / BLOCKED
- Tests: OK N passed / N failed
- Env vars: OK / [list new undocumented vars]

### Released
- Version: v[X.Y.Z] (was v[previous])
- Commit: [hash]
- Tag: v[X.Y.Z]
- Docker: [image:tag] (if applicable)

### Changelog summary
[3-5 bullet points of main changes]

### Next steps
- [ ] Push tag: `git push origin v[X.Y.Z]`
- [ ] Deploy to production
- [ ] Update any external docs/announcements
```

## Rules

- Phase 1 failures are hard stops -- never release with failing tests or CRITICAL CVEs
- HIGH CVEs are warnings, not blockers -- but must be documented in the release report
- Never auto-push to remote -- always leave the final `git push` to the human
- Semver rules: `patch` = bugfix, `minor` = new feature backward-compatible, `major` = breaking change
