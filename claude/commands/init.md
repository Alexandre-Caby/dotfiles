# Init — Bootstrap a new project with devcontainer

Initializes a complete project with devcontainer, base structure, and Claude Code configuration.

## Parameter

$ARGUMENTS = project stack (e.g., "node", "python", "rust", "full", "c-embedded", "base", "go")

## Auto-activated agents

- **`language-advisor`** — if the stack is not specified, analyze context to recommend
- **`devcontainer-init`** — generate the appropriate devcontainer.json

## Steps

### 1. Detect or ask for the stack

If `$ARGUMENTS` is empty, detect via existing files:
- `package.json` -> node
- `pyproject.toml` / `requirements.txt` -> python
- `Cargo.toml` -> rust
- `CMakeLists.txt` / `Makefile` with arm-none-eabi -> c-embedded
- Multiple languages -> full

### 2. Create the base structure

```bash
mkdir -p .devcontainer src tests docs
```

### 3. Generate devcontainer.json

Use the `devcontainer-init` agent to generate the file. Base on existing templates:

| Stack | Template source |
|---|---|
| `node` | `~/dotfiles/templates/devcontainer-node.json` |
| `python` | `~/dotfiles/templates/devcontainer-python.json` |
| `rust` | `~/dotfiles/templates/devcontainer-rust.json` |
| `c-embedded` | `~/dotfiles/templates/devcontainer-c-embedded.json` |
| `full` / polyglot | `~/dotfiles/templates/devcontainer-full.json` |
| `base` / `go` / other | `~/dotfiles/templates/devcontainer-base.json` (+ features to uncomment) |

Critical rules (always apply):
- **ANTHROPIC_API_KEY**, **TAVILY_API_KEY**, **GITHUB_TOKEN** in remoteEnv
- **Node.js 22** feature mandatory in ALL templates (required for Claude Code + MCP)
- VSCode extensions adapted to the stack
- `remoteUser: "vscode"`
- Do NOT put `install.sh` in postCreateCommand (VSCode dotfiles feature handles it)

### 4. Generate project .mcp.json (if relevant)

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/sequential-thinking"]
    }
  }
}
```

### 5. Generate base config files

Depending on the stack:

**Node/TypeScript**:
- `.prettierrc` (semi: false, singleQuote: true)
- `tsconfig.json` (strict: true)
- `.eslintrc.json`
- `vitest.config.ts`

**Python**:
- `pyproject.toml` (ruff, pytest, uv)
- `ruff.toml`

**Rust**:
- `clippy.toml`
- `rustfmt.toml`

**C/Embedded**:
- `.clang-format`
- `CMakeLists.txt` (base)

### 6. Create project CLAUDE.md

Create a `CLAUDE.md` at the project root:

```markdown
# [Project name]

## Description
[To be completed]

## Stack
- Language: [detected]
- Framework: [detected or to be completed]
- Tests: [detected runner]

## Structure
[generated tree]

## Project-specific conventions
[To be completed — global conventions apply via ~/.claude/CLAUDE.md]
```

### 7. Git init + first commit

```bash
git init
git add -A
git commit -m "feat: initial project setup with devcontainer

- devcontainer.json configured for [stack]
- Claude Code config (CLAUDE.md, .mcp.json)
- Linting and formatting config
- Test runner configured

Co-Authored-By: Claude <noreply@anthropic.com>"
```

## Output format

```
✅ Project initialized — [stack]

Files created:
  .devcontainer/devcontainer.json
  CLAUDE.md
  .mcp.json
  [other files depending on stack]

Next step: open in VSCode -> "Reopen in Container"
```
