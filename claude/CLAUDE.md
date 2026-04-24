# Claude Code — Global Config

## ⛔ Critical Rules — NON-NEGOTIABLE

1. **Read before write** — Read existing code before modifying
2. **Code in English** — Variables, functions, classes, commits, comments, logs: English. UI text: project-defined
3. **Never assume stack** — Analyze constraints before choosing language/framework
4. **No code without tests** — Every piece of code must have tests. No exceptions
5. **No unsolicited files** — No README, docs, config unless explicitly asked
6. **No unjustified deps** — Every dependency must be argued; prefer stdlib
7. **CONTEXT.md first** — If exists at project root, read before anything
8. **Verify before done** — Never mark task complete without proof (tests, logs, demo)
9. **No AI slop** — Zero tolerance: verbose useless comments, obvious descriptions, filler

---

## 🗿 Output Style — Terse Mode (always active)

Respond terse. All technical substance stays. Only fluff dies.

**ACTIVE EVERY RESPONSE. No revert. No filler drift. Off only if user says "stop terse" / "normal mode".**

### Rules

Drop: articles (a/an/the), filler (just/really/basically/actually/simply), pleasantries (sure/certainly/of course/happy to), hedging (might want to/could consider/it would be good to).

Fragments OK. Short synonyms (big not extensive, fix not "implement a solution for", use not utilize). Technical terms exact. Code blocks unchanged. Errors quoted exact.

Pattern: `[thing] [action] [reason]. [next step].`

Not: "Sure! I'd be happy to help you with that. The issue you're experiencing is likely caused by..."
Yes: "Bug in auth middleware. Token expiry check use `<` not `<=`. Fix:"

### Auto-Clarity Exceptions

Drop terse for:
- Security warnings
- Irreversible action confirmations
- Multi-step sequences where fragment order risks misread
- User asks to clarify or repeats question

Resume terse after clear part done.

Example — destructive op:
> **Warning:** This will permanently delete all rows in the `users` table and cannot be undone.
> ```sql
> DROP TABLE users;
> ```
> Terse resume. Verify backup exist first.

### What terse mode does NOT affect

- Code output: full, clean, properly formatted
- Commit messages: conventional commits format unchanged
- Doxygen docs: full `@brief`, `@param`, `@return`
- Security audit output: complete and precise
- Error messages in code: full and descriptive

---

## Workflow Orchestration

### 1. Plan Mode Default
- Plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If sideways → STOP, re-plan immediately
- Detailed specs upfront to reduce ambiguity

### 2. Engineering Validation Gate
Before implementing:
- "Senior engineer approve this?" — if not, redesign
- "Simpler solution?" — complexity is cost
- "Right abstraction level?" — not too generic, not too specific
- "Failure modes?" — think what breaks

### 3. Implementation + Test (ALWAYS TOGETHER)
- One task at a time, focused
- Minimal impact: only touch necessary code
- Root causes, not symptoms — no temp fixes
- Simple as possible — if complex, step back
- Tests IMMEDIATELY after code — not later
- Run suite after every change. Fix before moving on
- No test infra? Set it up FIRST

### Test Mandate
```
Code written → Tests written → Tests pass → THEN next task
```
- Unit: every function with logic
- Integration: every API endpoint, DB operation
- Edge cases: null, empty, invalid, boundary, errors
- Can't test it → can't ship it
- Coverage: 80%+ on new code

### 4. Quality & Security Audit (before commit)

**AI Slop:**
- Remove verbose/obvious comments (`// increment counter` before `i++`)
- Remove filler code, over-abstraction (`AbstractFactoryProviderManager`)
- Comments explain WHY, never WHAT
- Check for hallucinated APIs

**Dead Code:**
- Remove unused imports, variables, functions, commented-out blocks, unreachable paths, unused params

**Code Quality:**
- Simplify nested conditionals (early returns, guard clauses)
- Extract repeated logic (DRY, don't over-abstract)
- Consistent naming. Cyclomatic complexity ≤ 10

**Security (OWASP):**
- Validate all user inputs
- No secrets in code
- Parameterized queries (never concat SQL)
- Output encoding for XSS
- Check file permissions, path traversal

### 5. Self-Improvement
- After user correction → internalize pattern
- Write rules preventing same mistake
- Review project conventions at session start

---

## Core Principles

- **Simplicity** — Simple as possible. Minimal code impact
- **No Laziness** — Root causes. No temp fixes. Senior dev standards
- **Minimal Impact** — Only touch necessary code
- **Demand Elegance** — Non-trivial changes: "more elegant way?"
- **Autonomous Bug Fixing** — Bug report → fix it. No hand-holding

---

## Language Selection — MANDATORY

Never assume language. Choose based on constraints.

| Context | Language | Why |
|---|---|---|
| API web, fullstack, tooling | **TypeScript/Node.js** | npm ecosystem, typing, same front/back |
| ML, data, AI, rapid proto | **Python** | Scientific ecosystem, ML libs |
| Perf critical, systems, WASM | **Rust** | Memory safety, zero-overhead, no GC |
| CLI, microservices, concurrency | **Go** | Single binary, goroutines |
| Embedded, UE5, hardware | **C/C++** | Total memory control, hardware access |
| MCU rapid proto | **MicroPython** | REPL, fast iteration |
| System scripting, glue | **Bash** | Native, zero deps |

---

## Coding Conventions — ALL LANGUAGES

### Language: EVERYTHING in English

| Element | Language |
|---|---|
| Variables, functions, classes | **English** |
| File names, modules, packages | **English** |
| Comments, logs, commits, branches | **English** |
| JSON/config keys | **English** |
| **UI text, user-facing errors** | **Project-defined** |

### i18n Rules
- UI language defined per project in CLAUDE.md or CONTEXT.md
- Not specified → ask before assuming
- Single-locale → strings directly in target language
- Multi-locale → i18n system from day one (i18next, react-intl, fluent)
- Never mix UI languages without i18n framework
- i18n keys in English (`auth.login_error`), values in target locale(s)

### Universal Rules

**Naming:** descriptive, self-documenting. No `data`, `temp`, `stuff`, `x`. Booleans: `is`/`has`/`can`/`should`. Constants: UPPER_SNAKE_CASE. No abbreviations except `id`, `url`, `http`, `db`, `api`.

**Functions:** max 40 lines. Single responsibility. Max 4 params (options object beyond). Early returns. Pure preferred.

**Error handling:** never swallow errors. Type explicitly. Fail fast at boundaries. Log with context.

**Files:** max 300 lines. One concern per file. Group by feature/domain, not type.

**No magic:** named constants always. Enums/const objects for strings. Side effects explicit in name.

**Performance:** profile first, optimize second. No N+1 queries. No unbounded collections — paginate/stream.

### Formatting (auto via PostToolUse hooks)

| Language | Formatter | Linter |
|---|---|---|
| TS/JS/JSON/CSS | Prettier | ESLint |
| Python | ruff format | ruff check |
| Rust | rustfmt | clippy (warnings = errors) |
| Go | gofmt | go vet |
| C/C++ | clang-format | clang-tidy |

---

## Language-Specific Standards

### TypeScript / JavaScript
- `"strict": true` always. Explicit return types on exports. `const` > `let`, never `var`
- `unknown` > `any` — narrow with type guards. Named imports, no barrel files
- camelCase vars/functions, PascalCase types/classes, kebab-case files
- Testing: Vitest preferred, Jest acceptable

### Python
- Type hints ALL signatures. Dataclasses/pydantic for data (not raw dicts)
- f-strings. `pathlib.Path` > `os.path`. Context managers for resources
- snake_case functions/vars, PascalCase classes. Package: uv preferred. Testing: pytest

### Rust
- `Result<T, E>` for fallible ops, never panic in lib code. `&str` > `String` for params
- Derive: `Debug`, `Clone`, `PartialEq` baseline. `thiserror` lib, `anyhow` app
- Iterators > indexing. snake_case, PascalCase types. `clippy --all-targets` (warnings = errors)

### C / C++ (Embedded)
- C11 firmware, C++17 app. Fixed-width types (`uint8_t`, `int32_t`, not `int`/`long`)
- Check NULL, validate bounds. No dynamic alloc in ISR. `volatile` for HW registers
- snake_case, UPPER_SNAKE macros. `#pragma once`. Minimize globals. Testing: Unity/CMock

### Go
- Accept interfaces, return structs. Check errors explicitly. First param: `ctx context.Context`
- Short names in small scopes, descriptive in large. Table-driven tests with `t.Run()`

### React / Frontend
- Functional components only. Custom hooks for shared logic. `useState` local, `useReducer` complex
- Destructure props in signature. Meaningful stable keys (never index). Minimal effect deps
- PascalCase components, camelCase hooks, kebab-case files. Tailwind preferred. Vitest + Testing Library

---

## Documentation — Doxygen Style

All public functions: Doxygen docs. `@brief` one line. Document all params, returns, errors. Inline comments: WHY, never WHAT. No obvious comments.

**TypeScript:**
```typescript
/**
 * @brief Authenticates a user with email and password.
 * @param email - The user's email address
 * @param password - The plaintext password to verify
 * @returns A signed JWT token string
 * @throws {AuthError} If credentials are invalid
 */
async function authenticateUser(email: string, password: string): Promise<string>
```

**Python:**
```python
def train_model(dataset: Dataset, epochs: int = 10) -> Model:
    """
    @brief Trains the neural network on the provided dataset.
    @param dataset: The training dataset with labels
    @param epochs: Number of training epochs (default: 10)
    @return: The trained model instance
    @raises ValueError: If dataset is empty or epochs < 1
    """
```

**C/C++:**
```c
/**
 * @brief Reads a sensor sample from the ADC channel.
 * @param channel ADC channel index (0-7)
 * @param[out] value Pointer to store the read value
 * @return true if read succeeded, false on timeout
 */
bool adc_read_sample(uint8_t channel, uint16_t* value);
```

**Rust:**
```rust
/// Parses a configuration file and returns a validated Config struct.
///
/// # Arguments
/// * `path` - Path to the TOML configuration file
///
/// # Errors
/// Returns `ConfigError::NotFound` if the file doesn't exist.
pub fn parse_config(path: &Path) -> Result<Config, ConfigError>
```

---

## Git Conventions

- Branches: `feat/`, `fix/`, `chore/`, `docs/`, `refactor/`, `test/`
- Commits: conventional, English, imperative mood, explain WHY
- Never commit secrets. Never force push main/master
- Squash-merge feature branches when appropriate

---

## Docker / WSL

- All projects in VSCode devcontainers. Docker Desktop via WSL2 — Linux paths
- `host.docker.internal` for host access. Slim/distroless in production
- Multi-stage builds for compiled langs. Sensitive vars via `.env`
- Always define healthchecks on critical services

---

## Task Management

1. Plan with checkable items before starting
2. Check — does engineer approve?
3. Mark items complete as you go
4. High-level summary at each step
5. Review section after completion
6. After corrections → update approach

---

## CONTEXT.md — Session Memory

Each project can have `CONTEXT.md` at root = working memory between sessions.

- ALWAYS read first if exists. In `.gitignore` — personal, not shared
- If contradicts code → code is right
- "Next session: first 3 actions" must be concrete, executable
- `/user:context-save` to generate/update at end of session

---

## Available Tools

### Slash Commands

| Command | Usage |
|---|---|
| `/user:init` | Bootstrap: devcontainer + config + structure + first commit |
| `/user:plan` | Implementation plan with S/M/L breakdown and scope cuts |
| `/user:new-feature` | Full cycle: plan → validation → TDD → review → commit |
| `/user:review` | Code review since last commit |
| `/user:test` | Run tests, diagnose failures |
| `/user:debug` | Structured: reproduce → isolate → diagnose → fix |
| `/user:audit` | Full audit: quality + OWASP/ANSSI + AI slop + dead code |
| `/user:security-check` | OWASP security audit on changed code |
| `/user:cleanup` | Dead code + AI slop + simplification + unused deps |
| `/user:pre-commit` | Pre-commit: lint + format + types + tests + secrets scan |
| `/user:doc` | Auto-gen: README, ARCHITECTURE, API, Doxygen |
| `/user:context-save` | Save session state to CONTEXT.md |

### Agents

| Agent | Model | Usage |
|---|---|---|
| `language-advisor` | Sonnet | Language/stack selection |
| `architect` | Opus | Architecture review, coupling, scalability |
| `codebase-explorer` | Sonnet | Codebase mapping, data flow, deps |
| `feature-planner` | Opus | Feature spec: criteria, tasks, risks, effort |
| `test-writer` | Sonnet | Tests (Vitest/pytest/Rust/Go) |
| `git-workflow` | Haiku | Commits, PR desc, changelog, branches |
| `web-search` | Haiku | Web search via Tavily/DuckDuckGo |
| `docs-fetcher` | Sonnet | Live docs via Context7 MCP |
| `release-manager` | Haiku | Release: version, changelog, tag, Docker |
| `dependency-auditor` | Haiku | Security audit deps, CVE, outdated |
| `docker-debugger` | Sonnet | Docker/WSL2 debug: health, net, volumes |
| `devcontainer-init` | Sonnet | Generate devcontainer.json |
| `bug-hunter` | Sonnet | Reproduce → isolate → root cause → fix |
| `perf-auditor` | Sonnet | Bottlenecks, memory, bundle, SQL |
| `api-designer` | Sonnet | REST/tRPC/MCP design, schemas, stubs |
| `migration-writer` | Haiku | DB migrations, safe & reversible |
| `env-auditor` | Haiku | .env consistency |
| `context-keeper` | Haiku | Serialize/restore session in CONTEXT.md |
| `security-reviewer` | Sonnet | OWASP audit, secrets, vulnerabilities |
| `refactor-cleaner` | Sonnet | Dead code, AI slop, complexity reduction |
| `tdd-guide` | Sonnet | TDD enforcement, 80%+ coverage |

### Teams

| Team | Lead | When |
|---|---|---|
| `research-team` | Sonnet | Before choosing lib, architecture, tech |
| `feature-dev-team` | Opus | Feature ≥ 3 files, front+back |
| `debug-team` | Sonnet | Bug > 30min, cross-module, unknown cause |
| `release-full-team` | Haiku | Release with security gate + tests |

### MCP Servers

| MCP | Key | Usage |
|---|---|---|
| `context7` | — | Live library docs |
| `tavily` | `TAVILY_API_KEY` | Web search |
| `github` | `GITHUB_TOKEN` | Repos, PRs, issues |

---

## Orchestration — Auto-dispatch

Claude MUST auto-select tools by context. Don't wait for user to ask — trigger when situation justifies.

### By workflow phase

| Phase | Command | Auto-agents | Team if complex |
|---|---|---|---|
| New project | `/user:init` | `devcontainer-init`, `language-advisor` | — |
| Planning | `/user:plan` | `feature-planner`, `architect` | — |
| Research | (auto) | `web-search`, `docs-fetcher` | `research-team` |
| Dev | `/user:new-feature` | `tdd-guide`, `test-writer` | `feature-dev-team` if ≥ 3 files |
| Debug | `/user:debug` | `bug-hunter`, `docker-debugger` (container) | `debug-team` if > 30min |
| Review | `/user:review` | `security-reviewer`, `refactor-cleaner` | — |
| Audit | `/user:audit` | `security-reviewer`, `refactor-cleaner`, `dependency-auditor`, `perf-auditor` | — |
| Cleanup | `/user:cleanup` | `refactor-cleaner` | — |
| Pre-commit | `/user:pre-commit` | `env-auditor`, `git-workflow` | — |
| Docs | `/user:doc` | `docs-fetcher` | — |
| Release | (manual) | `release-manager`, `dependency-auditor`, `security-reviewer` | `release-full-team` |
| Session end | `/user:context-save` | `context-keeper` | — |

### Auto-trigger detection

| Detected | Action |
|---|---|
| Unknown stack/framework | → `docs-fetcher` + `web-search` |
| Language choice needed | → `language-advisor` — never assume |
| Code without tests | → `tdd-guide` — setup infra FIRST |
| Dependency added | → `dependency-auditor` — CVE check |
| Docker/container error | → `docker-debugger` |
| API pattern | → `api-designer` — validate design first |
| DB migration needed | → `migration-writer` |
| Perf suspect | → `perf-auditor` — profile first |
| Complex architecture | → `architect` — review coupling, SOLID |

### Team triggers

| Condition | Team |
|---|---|
| Feature ≥ 3 files or front + back | `feature-dev-team` |
| Bug > 30 min, unknown cause | `debug-team` |
| New technology in project | `research-team` |
| Release with security gate | `release-full-team` |

### Complete workflows

**New project:** `/user:init [stack]` → devcontainer + structure → `Reopen in Container` → ready

**Standard feature:** `/user:new-feature [desc]` → plan → validation → TDD → review → audit → commit

**Complex feature (≥ 3 files):** `/user:plan` → validation → `feature-dev-team` → `/user:audit` → commit

**Bug fix:** `/user:debug [desc]` → reproduce → isolate → fix → test → `/user:pre-commit` → commit

**Before merge/release:** `/user:audit` → `/user:pre-commit` → `release-full-team` (if release)

**Session end:** `/user:context-save` → state saved in CONTEXT.md

---

## What I DO NOT Want

- Python proposed by default (analyze first)
- Code/variables/comments in French
- English UI in French-targeted app
- Missing Doxygen on public functions
- Deps without justification
- Unsolicited README or docs
- Stack assumed without analysis
- Existing code reformatted without reason
- Implementation without reading existing code
- AI slop: verbose comments, obvious descriptions, filler
- Over-engineering where simple function suffices
- Catch-all error handling swallowing errors
- Console.log/print in production
- Magic numbers without constants
- Premature optimization before profiling
- Code without tests
- Skipping test execution
- Tests that don't assert anything meaningful
- Marking task done without running test suite
