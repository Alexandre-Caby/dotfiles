# Claude Code — Configuration globale

## ⛔ Critical Rules — NON-NEGOTIABLE

1. **Read before write** — ALWAYS read existing code before modifying or proposing changes
2. **Code in English** — Variables, functions, classes, commits, comments, logs: English. UI text: French
3. **Never assume the stack** — Analyze constraints before choosing a language or framework
4. **No code without tests** — EVERY piece of code must have tests. No exceptions. Write tests, run them, prove it works.
5. **No unsolicited files** — No README, docs, or config files unless explicitly asked
6. **No unjustified deps** — Every new dependency must be argued; prefer stdlib when possible
7. **CONTEXT.md first** — If it exists at project root, read it before doing anything
8. **Verify before done** — Never mark a task complete without proving it works (run tests, check logs, demonstrate correctness)
9. **No AI slop** — Zero tolerance for verbose useless comments, obvious code descriptions, filler text

---

## Workflow Orchestration

### 1. Plan Mode Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately — don't keep pushing
- Write detailed specs upfront to reduce ambiguity
- Use plan mode for verification steps, not just building

### 2. Engineering Validation Gate
Before implementing ANY plan, ask:
- "Would a senior engineer approve this?" — if not, redesign
- "Is there a simpler solution?" — complexity is a cost, not a feature
- "Is this the right abstraction level?" — not too generic, not too specific
- "What are the failure modes?" — think about what breaks, not just what works

### 3. Implementation + Test (ALWAYS TOGETHER)
- One task at a time, focused execution
- Minimal impact: changes should only touch what's necessary
- Find root causes, not symptoms — no temporary fixes
- Every change as simple as possible — if it feels complex, step back
- **Write tests IMMEDIATELY after writing code** — not later, not "if time permits"
- Run the test suite after every change. If tests fail, fix before moving on.
- If no test infrastructure exists, set it up FIRST before writing feature code.

### Test Mandate
```
Code written → Tests written → Tests pass → THEN move to next task
```
- Unit tests: every function with logic
- Integration tests: every API endpoint, every DB operation
- Edge cases: null, empty, invalid, boundary, error paths
- If you can't test it, you can't ship it
- Coverage target: 80%+ on new code

### 4. Quality & Security Audit (mandatory before commit)
Run this checklist on EVERY piece of code:

**AI Slop Detection:**
- Remove verbose/obvious comments (`// increment counter` before `i++`)
- Remove filler code that adds no value
- Remove over-abstraction (no `AbstractFactoryProviderManager`)
- Ensure comments explain WHY, never WHAT
- Check for hallucinated APIs or non-existent methods

**Dead Code & Cleanup:**
- Remove unused imports, variables, functions
- Remove commented-out code blocks
- Remove unreachable code paths
- Remove unused parameters

**Code Quality:**
- Simplify nested conditionals (early returns, guard clauses)
- Extract repeated logic (DRY, but don't over-abstract)
- Ensure consistent naming within the file and project
- Check cyclomatic complexity — refactor if > 10

**Security (OWASP):**
- Validate all user inputs
- No secrets, tokens, or keys in code
- Parameterized queries (never string-concat SQL)
- Output encoding for XSS prevention
- Check file permissions and path traversal

### 5. Self-Improvement Loop
- After ANY correction from the user, internalize the pattern
- Write rules for yourself that prevent the same mistake
- Review project conventions at session start

---

## Core Principles

- **Simplicity First** — Make every change as simple as possible. Impact minimal code.
- **No Laziness** — Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact** — Changes should only touch what's necessary. Avoid introducing bugs.
- **Demand Elegance** — For non-trivial changes: pause and ask "is there a more elegant way?"
- **Autonomous Bug Fixing** — When given a bug report: just fix it. Don't ask for hand-holding.

---

## Language Selection — MANDATORY ANALYSIS

**Never assume a language. Always choose based on project constraints.**

| Context | Language | Why |
|---|---|---|
| API web, fullstack, tooling | **TypeScript/Node.js** | npm ecosystem, strong typing, same front/back |
| ML, data science, AI, rapid prototyping | **Python** | Scientific ecosystem, ML libraries |
| Performance critical, systems, WASM | **Rust** | Memory safety, zero-overhead, no GC |
| CLI tools, microservices, high concurrency | **Go** | Single binary, goroutines, simple deploy |
| Embedded, UE5 plugins, hardware, low-level | **C/C++** | Total memory control, direct hardware access |
| MCU rapid prototyping | **MicroPython** | REPL, fast iteration |
| System scripting, glue code | **Bash** | Native, zero deps |

---

## Language-Specific Standards

### TypeScript / JavaScript
```
- Strict mode always (`"strict": true` in tsconfig)
- Explicit return types on exported functions
- Prefer `const` over `let`, never `var`
- Use `unknown` over `any` — narrow with type guards
- Error handling: typed errors, never catch-all silently
- Imports: named imports, no barrel files in libraries
- Naming: camelCase variables/functions, PascalCase types/classes
- File naming: kebab-case (auth-service.ts)
- Testing: Vitest preferred, Jest acceptable
- Formatting: Prettier (auto via hook)
- Linting: ESLint with strict rules
```

### Python
```
- Type hints on ALL function signatures (params + return)
- Use dataclasses or pydantic for data structures, not raw dicts
- f-strings over .format() or % formatting
- Use pathlib.Path over os.path
- Context managers for resources (files, connections, locks)
- Import order: stdlib → third-party → local (isort handles this)
- Naming: snake_case functions/vars, PascalCase classes, UPPER_SNAKE constants
- Package management: uv preferred, pip acceptable
- Testing: pytest exclusively
- Formatting: ruff format (auto via hook)
- Linting: ruff check with strict rules
```

### Rust
```
- Use Result<T, E> for fallible operations, never panic in library code
- Prefer &str over String for function params when ownership not needed
- Derive traits generously: Debug, Clone, PartialEq as baseline
- Use thiserror for library errors, anyhow for application errors
- Prefer iterators over indexing loops
- Naming: snake_case functions/vars, PascalCase types, SCREAMING_SNAKE constants
- Modules: one concern per module, pub only what's needed
- Testing: #[cfg(test)] mod tests in same file for unit, tests/ dir for integration
- Formatting: rustfmt (auto via hook)
- Linting: clippy --all-targets (treat warnings as errors)
```

### C / C++ (Embedded)
```
- C11 for firmware, C++17 for application code
- Fixed-width types always (uint8_t, int32_t, not int/long)
- Defensive: check NULL pointers, validate array bounds
- No dynamic allocation in ISR context
- Volatile for hardware registers and shared ISR variables
- Naming: snake_case for functions/vars, UPPER_SNAKE for macros/constants
- Header guards or #pragma once
- Minimize global state — pass context structs
- Testing: Unity or CMock for embedded, Google Test for C++
- Formatting: clang-format (auto via hook)
```

### Go
```
- Accept interfaces, return structs
- Errors are values — check them explicitly, no blank identifier
- Context propagation: first param is always ctx context.Context
- Naming: short variable names in small scopes, descriptive in large
- Package naming: short, lowercase, no underscores
- Testing: table-driven tests with t.Run()
- Formatting: gofmt (auto via hook)
```

### React / Frontend
```
- Functional components only, no class components
- Custom hooks for shared logic (useAuth, useFetch)
- State: useState for local, useReducer for complex, context sparingly
- Props: destructure in function signature, type with interface
- Keys: meaningful and stable, never array index
- Effects: minimal dependencies, cleanup functions for subscriptions
- Naming: PascalCase components, camelCase hooks (useXxx), kebab-case files
- Styling: Tailwind CSS preferred, CSS modules acceptable
- Testing: Vitest + Testing Library
- No prop drilling beyond 2 levels — use context or composition
```

---

## Code Language Rules — ABSOLUTE

| Element | Language | Examples |
|---|---|---|
| Variables, functions, classes | **English** | `userProfile`, `fetchData`, `parseConfig` |
| File names, modules, packages | **English** | `auth-service.ts`, `data_processor.py` |
| Code comments | **English** | `// Check if token is expired` |
| Log messages | **English** | `logger.info("Connection established")` |
| Branch names, commits | **English** | `feat/user-authentication` |
| JSON/config keys | **English** | `{ "maxRetries": 3, "timeout": 5000 }` |
| **UI text displayed to user** | **French** (or i18n) | See i18n rules below |
| **User-facing error messages** | **French** (or i18n) | `"Connexion impossible. Réessayez."` |

### i18n Rules
- Default locale: `fr-FR`
- Single-locale app (personal/FR) → French strings directly in code
- Multi-locale or public app → i18n system from day one (i18next, react-intl)
- Never hardcode English UI text in a French-targeted app

---

## Documentation — Doxygen Style

All public functions MUST have Doxygen-style documentation.

**Rules:**
- `@brief`: one concise line describing the function
- Document ALL public params, return values, and possible errors
- Inline comments (`//`) explain the WHY, never the WHAT
- No obvious comments: `// increment counter` before `i++` is forbidden
- Document side effects and non-obvious preconditions

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
- Commits: conventional commits in English (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`)
- Never commit secrets, tokens, or API keys
- Never force push to main/master
- Squash-merge feature branches when appropriate
- Commit messages: imperative mood, explain WHY not WHAT

---

## Docker / WSL Environment

- All projects run in VSCode devcontainers
- Docker Desktop via WSL2 — Linux paths in WSL (`/home/user/...`), not Windows
- `host.docker.internal` to access host from container
- Images: slim or distroless in production
- Multi-stage builds for compiled languages (Rust, TypeScript)
- Sensitive variables via `.env` (never in docker-compose.yml)
- Always define healthchecks on critical services

---

## Task Management

1. **Plan First**: Write plan with checkable items before starting
2. **Verify Plan**: Check in — does the engineer approve?
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section after completion
6. **Capture Lessons**: After corrections, update approach

---

## CONTEXT.md — Session Memory

Each project can have a `CONTEXT.md` at its root. This file IS the working memory between sessions.

**Rules:**
- ALWAYS read `CONTEXT.md` first if it exists
- `CONTEXT.md` is in `.gitignore` — personal working file, not shared code
- If `CONTEXT.md` contradicts actual code, code is always right
- "Next session: first 3 actions" must be concrete and executable
- Use `/user:context-save` to generate/update at end of session

---

## Available Tools

### Slash Commands

| Command | Usage |
|---|---|
| `/user:plan` | Implementation plan with S/M/L breakdown and scope cuts |
| `/user:review` | Structured code review since last commit |
| `/user:test` | Run tests, diagnose failures |
| `/user:debug` | Structured diagnosis: reproduce → isolate → diagnose → fix |
| `/user:security-check` | OWASP security audit on changed code |
| `/user:context-save` | Save session state to CONTEXT.md |

### Agents

| Agent | Model | Usage |
|---|---|---|
| `language-advisor` | Sonnet | Language/stack selection based on project context |
| `architect` | Opus | Architecture review, coupling, scalability, red flags |
| `codebase-explorer` | Sonnet | Codebase mapping, data flow, dependencies |
| `feature-planner` | Opus | Full feature spec: criteria, tasks, risks, effort |
| `test-writer` | Sonnet | Complete tests (Vitest/pytest/Rust/Go) on new code |
| `git-workflow` | Haiku | Conventional commits, PR desc, changelog, branch naming |
| `web-search` | Haiku | Web search via Tavily/DuckDuckGo/GitHub/npm/PyPI |
| `docs-fetcher` | Sonnet | Live docs via Context7 MCP, exact versions, API surface |
| `release-manager` | Haiku | Full release: version bump, changelog, git tag, Docker |
| `dependency-auditor` | Haiku | Security audit deps (npm/pip/cargo/go), CVE, outdated |
| `docker-debugger` | Sonnet | Debug Docker/WSL2: health, networking, volumes, perms |
| `devcontainer-init` | Sonnet | Generate `.devcontainer/devcontainer.json` for project |
| `bug-hunter` | Sonnet | Structured diagnosis: reproduce → isolate → root cause → fix |
| `perf-auditor` | Sonnet | Runtime bottlenecks, memory, bundle, SQL, GPU/ML |
| `api-designer` | Sonnet | REST/tRPC/MCP design: routes, Zod/Pydantic schemas, stubs |
| `migration-writer` | Haiku | DB migrations (Prisma/Alembic/Diesel/SQL), safe & reversible |
| `env-auditor` | Haiku | .env / .env.example / devcontainer.json consistency |
| `context-keeper` | Haiku | Serialize/restore session state in CONTEXT.md |
| `security-reviewer` | Sonnet | OWASP audit, secrets detection, vulnerability remediation |
| `refactor-cleaner` | Sonnet | Dead code, AI slop, duplicates, complexity reduction |
| `tdd-guide` | Sonnet | TDD enforcement, write-tests-first, 80%+ coverage |

### Teams

| Team | Lead | When |
|---|---|---|
| `research-team` | Sonnet | Before choosing a library, architecture pattern, technology |
| `feature-dev-team` | Opus | Feature ≥ 3 files, front+back, tests + review simultaneous |
| `debug-team` | Sonnet | Bug resistant > 30min, cross-module, unknown cause |
| `release-full-team` | Haiku | Full release with security gate + tests before shipping |

### MCP Servers

| MCP | Key Required | Usage |
|---|---|---|
| `context7` | — | Live library docs (always active) |
| `tavily` | `TAVILY_API_KEY` | Web search with structured results |
| `github` | `GITHUB_TOKEN` | Repos, PRs, issues, code search |

---

## Workflows

**New Feature:**
1. `/user:plan` → spec + breakdown + risks + scope cuts
2. Engineering validation gate → approve or redesign
3. `research-team` (if unknown technology)
4. `feature-dev-team` (if feature ≥ 3 files)
5. `/user:review` → code review before commit
6. Quality & Security Audit (section 4 above)
7. `git-workflow` → conventional commits + PR desc

**Before Release:**
1. `/user:security-check` → security audit
2. `dependency-auditor` → CVE + outdated
3. `/user:test` → verify everything passes
4. `release-manager` → version bump + changelog + tag

**Complex Bug:**
1. `/user:debug` → structured diagnosis
2. `docs-fetcher` → check official dependency docs
3. `architect` → review if cause is structural

**End of Session:**
1. `/user:context-save` → save state to CONTEXT.md

---

## What I DO NOT Want

- Python proposed by default for any backend (analyze first)
- Code, variables, or comments written in French
- English UI text in a French-targeted app
- Missing Doxygen documentation on public functions
- Dependencies added without justification
- Unsolicited README or documentation files
- Stack assumed without analyzing project context
- Existing code reformatted without explicit reason
- Implementation started without reading existing code first
- Verbose/obvious comments (AI slop)
- Over-engineered abstractions where a simple function suffices
- catch-all error handling that swallows errors silently
- Console.log/print left in production code
- Magic numbers without named constants
- Premature optimization before profiling
- Code without tests — NEVER deliver code that hasn't been tested
- Skipping test execution ("I'll run them later")
- Tests that don't assert anything meaningful
- Marking a task as done without running the test suite
