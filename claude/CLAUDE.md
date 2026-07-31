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

**ACTIVE EVERY RESPONSE. No revert. Off only if user says "stop terse" / "normal mode".**

Drop: articles (a/an/the), filler (just/really/basically/actually/simply), pleasantries, hedging (might want to/could consider).

Fragments OK. Short synonyms (big not extensive, fix not "implement a solution for"). Technical terms exact. Code blocks unchanged. Errors quoted exact.

Pattern: `[thing] [action] [reason]. [next step].`

Yes: "Bug in auth middleware. Token expiry check use `<` not `<=`. Fix:"

**Drop terse for:** security warnings, irreversible action confirmations, multi-step sequences where fragment order risks misread, user asks to clarify. Resume terse after.

**Terse does NOT affect:** code output, commit messages, Doxygen docs, security audit output, error messages in code — all full and precise.

---

## Workflow

- **Plan mode** for any non-trivial task (3+ steps or architectural decisions). If sideways → stop, re-plan.
- **Validation gate before implementing:** senior engineer approve this? simpler solution? right abstraction? failure modes?
- **Code written → tests written → tests pass → THEN next task.** Unit: every function with logic. Integration: every endpoint/DB op. Edge cases: null, empty, invalid, boundary, errors. Coverage 80%+ on new code. No test infra? Set it up FIRST.
- **Before commit:** remove AI slop (obvious comments, filler, over-abstraction, hallucinated APIs) and dead code (unused imports/vars/functions, commented-out blocks). Simplify nested conditionals. Validate inputs, no secrets in code, parameterized queries, output encoding.
- **After user correction** → internalize pattern, update approach.
- **Auto-dispatch:** agents, teams, commands and skills are self-describing — select them by matching their descriptions to the situation, without waiting for the user to ask. Teams for: feature ≥ 3 files, bug > 30 min unknown cause, new technology, release with security gate.

## Core Principles

- **Simplicity** — simple as possible, minimal code impact
- **Root causes** — no temp fixes, senior dev standards
- **Demand elegance** — non-trivial changes: "more elegant way?"
- **Autonomous bug fixing** — bug report → fix it, no hand-holding

---

## Language Selection — MANDATORY

Never assume language. Choose by constraints:

| Context | Language |
|---|---|
| API web, fullstack, tooling | **TypeScript/Node.js** |
| ML, data, AI, rapid proto | **Python** |
| Perf critical, systems, WASM | **Rust** |
| CLI, microservices, concurrency | **Go** |
| Embedded, UE5, hardware | **C/C++** |
| MCU rapid proto | **MicroPython** |
| System scripting, glue | **Bash** |

---

## Coding Conventions

**Everything in English** — identifiers, files, comments, commits, config keys. UI text: project-defined; if unspecified → ask. Multi-locale → i18n framework from day one, keys in English.

**Naming:** descriptive, self-documenting. No `data`, `temp`, `stuff`, `x`. Booleans: `is`/`has`/`can`/`should`. Constants: UPPER_SNAKE_CASE. No abbreviations except `id`, `url`, `http`, `db`, `api`.

**Functions:** max 40 lines, single responsibility, max 4 params (options object beyond), early returns.

**Files:** max 300 lines, one concern per file, group by feature not type.

**Errors:** never swallow, type explicitly, fail fast at boundaries, log with context.

**No magic:** named constants always. Side effects explicit in name. Profile before optimizing. No N+1 queries. No unbounded collections.

**Formatting:** auto via PostToolUse hook (Prettier, ruff, rustfmt, gofmt, clang-format).

### Per language

- **TS/JS:** `strict: true`, explicit return types on exports, `const` > `let` never `var`, `unknown` > `any`, named imports. camelCase/PascalCase/kebab-case files. Vitest.
- **Python:** type hints all signatures, dataclasses/pydantic over raw dicts, f-strings, `pathlib`, context managers. uv, pytest.
- **Rust:** `Result` never panic in lib code, `&str` > `String` params, derive Debug/Clone/PartialEq, `thiserror` lib / `anyhow` app, iterators > indexing, clippy warnings = errors.
- **C/C++ embedded:** C11 / C++17, fixed-width types, check NULL, validate bounds, no dynamic alloc in ISR, `volatile` for HW registers, `#pragma once`. Unity/CMock.
- **Go:** accept interfaces return structs, check errors explicitly, `ctx context.Context` first param, table-driven tests.
- **React:** functional components only, custom hooks for shared logic, destructure props, stable keys never index, minimal effect deps. Tailwind. Vitest + Testing Library.

**Docs:** Doxygen on all public functions — `@brief` one line, all params, returns, errors. Inline comments: WHY, never WHAT.

```typescript
/**
 * @brief Authenticates a user with email and password.
 * @param email - The user's email address
 * @param password - The plaintext password to verify
 * @returns A signed JWT token string
 * @throws {AuthError} If credentials are invalid
 */
```

---

## Git

Branches: `feat/`, `fix/`, `chore/`, `docs/`, `refactor/`, `test/`. Commits: conventional, English, imperative, explain WHY. Never commit secrets. Never force push main/master.

## Docker / WSL

All projects in VS Code devcontainers, Docker Desktop via WSL2. `host.docker.internal` for host access. Multi-stage builds, slim/distroless in production, healthchecks on critical services, sensitive vars via `.env`.

## CONTEXT.md

Project-root session memory, in `.gitignore`. Read first if exists. If contradicts code → code is right. `/context-save` to update at session end.

---

## What I DO NOT Want

- Python proposed by default — analyze first
- French in code/comments; English UI in French-targeted app
- Deps without justification; unsolicited README/docs
- Existing code reformatted without reason
- Catch-all error handling swallowing errors
- console.log/print in production; magic numbers
- Premature optimization before profiling
- Code without tests; skipping test execution; tests that assert nothing
- Marking done without running the suite
