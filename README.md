# Dotfiles

Claude Code configuration synced across machines via Git. Deployed automatically in VSCode devcontainers.

## Structure

```
dotfiles/
├── install.sh                    ← Auto-executed by VSCode Dotfiles feature
├── claude/
│   ├── CLAUDE.md                 ← Global rules, standards, workflows
│   ├── settings.json             ← Hooks, permissions, environment
│   ├── agents/                   ← 18 specialized agents
│   │   ├── architect.md          ← Architecture review (Opus)
│   │   ├── bug-hunter.md         ← Structured diagnosis (Sonnet)
│   │   ├── codebase-explorer.md  ← Codebase mapping (Sonnet)
│   │   ├── feature-planner.md    ← Feature spec + breakdown (Opus)
│   │   ├── test-writer.md        ← Test generation (Sonnet)
│   │   ├── ...                   ← 13 more agents
│   │   └── teams/                ← 4 orchestrated multi-agent teams
│   │       ├── research.md
│   │       ├── feature-dev.md
│   │       ├── debug-team.md
│   │       └── release-full-team.md
│   ├── commands/                 ← 6 slash commands
│   │   ├── plan.md               ← /user:plan — Implementation planning
│   │   ├── review.md             ← /user:review — Code review
│   │   ├── test.md               ← /user:test — Run & diagnose tests
│   │   ├── debug.md              ← /user:debug — Structured debugging
│   │   ├── security-check.md     ← /user:security-check — OWASP audit
│   │   └── context-save.md       ← /user:context-save — Session memory
│   └── skills/                   ← Domain knowledge
│       ├── nxio.md               ← NXIO project context
│       ├── polyglot-stack.md     ← Multi-language conventions
│       ├── docker-wsl.md         ← Docker/WSL patterns
│       ├── api-conventions.md    ← API design standards
│       ├── testing-philosophy.md ← Testing approach
│       ├── dotfiles-authoring.md ← Meta: how to author dotfiles
│       ├── secure-craft/         ← Security-first development
│       └── aesthetic-craft/      ← Design system (+ web/email/visual/dataviz)
├── scripts/
│   └── session-handoff.sh        ← Session state export
└── templates/
    ├── .mcp.json                 ← MCP server template for new projects
    ├── .env.example              ← Environment variables template
    ├── devcontainer-full.json    ← Full-featured devcontainer
    ├── devcontainer-node.json    ← Node.js/TypeScript devcontainer
    ├── devcontainer-python.json  ← Python devcontainer
    ├── devcontainer-rust.json    ← Rust devcontainer
    └── docker-compose.dev.yml   ← Development compose template
```

## What's Included

### Hooks (settings.json)
- **PreToolUse** — Blocks destructive bash commands before execution (rm -rf /, mkfs, fork bomb)
- **PostToolUse** — Auto-formats files on Write/Edit (Prettier, ruff, rustfmt, gofmt, clang-format)
- **Notification** — Desktop notification when Claude needs attention
- **Stop** — Desktop notification when task completes

### Permissions
- 50+ whitelisted commands (git, docker, npm, cargo, python, embedded toolchain...)
- Deny rules for destructive operations (force push main, rm -rf /, chmod 777)

### Workflow: Plan → Validate → Dev → Audit
Every task follows an engineering-grade workflow:
1. Plan with `/user:plan` — breakdown, risks, scope cuts
2. Engineer validates the approach before implementation
3. Develop with focused execution
4. Audit with `/user:review` + `/user:security-check` — AI slop detection, dead code, OWASP

## Setup — New Machine

```bash
# 1. Clone in WSL
git clone git@github.com:Alexandre-Caby/dotfiles.git ~/dotfiles

# 2. Run install
chmod +x ~/dotfiles/install.sh
bash ~/dotfiles/install.sh

# 3. VSCode settings (one-time)
# Settings → search "dotfiles" → set:
#   Repository: https://github.com/Alexandre-Caby/dotfiles
#   Target Path: ~/dotfiles
#   Install Command: bash ~/dotfiles/install.sh

# 4. Environment variables in WSL (~/.bashrc)
export ANTHROPIC_API_KEY="sk-ant-..."
export GITHUB_TOKEN="ghp_..."
# Optional:
export TAVILY_API_KEY="tvly-..."
```

## Sync Between Machines

```bash
# After changes
git add -A && git commit -m "chore: update claude config" && git push

# On other machine
git pull
# Next devcontainer will use the updated version automatically
```

## Using in Claude Code

```bash
# Slash commands (in any devcontainer)
/user:plan              # Plan a feature with breakdown
/user:review            # Code review since last commit
/user:test              # Run tests and diagnose failures
/user:debug             # Structured bug diagnosis
/user:security-check    # OWASP security audit
/user:context-save      # Save session state

# Agents (invoked by Claude automatically or via prompt)
# "Use the architect agent to review this"
# "Run the research team on Redis vs Kafka"
# "Use test-writer to generate tests for auth module"
```

## License

Personal configuration. MIT.
