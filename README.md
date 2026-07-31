# Dotfiles

Claude Code configuration synced across machines via Git. Deployed automatically in VSCode devcontainers via the Dotfiles feature.

## Structure

```
dotfiles/
├── install.sh                    ← Auto-executed by VSCode Dotfiles feature
├── .github/workflows/ci.yml     ← Tests + shellcheck + install smoke test
├── claude/
│   ├── CLAUDE.md                 ← Global rules and standards (kept lean — loaded every session)
│   ├── settings.json             ← Permissions, hooks, model, notifications
│   ├── agents/                   ← 22 specialized agents (+ teams/ with 4 orchestrations)
│   ├── commands/                 ← 9 slash commands (/audit, /debug, /plan, ...)
│   ├── hooks/                    ← Tested hook scripts (see below)
│   └── skills/                   ← Domain knowledge + vendored skills
└── templates/                    ← devcontainer.json variants, compose, .env.example
```

Agents, commands, teams, and skills are self-describing (frontmatter); Claude Code
discovers them at runtime — no inventory is maintained here or in CLAUDE.md, so
nothing can drift.

## Hooks (all tested — `claude/hooks/*.test.sh`)

| Hook | Script | Purpose |
|---|---|---|
| PreToolUse | `pre-guard.sh` | Blocks destructive commands + secret-file reads anywhere in a command line (defense in depth behind `permissions.deny`) |
| PostToolUse | `post-format.sh` | Auto-formats written files (Prettier, ruff, rustfmt, gofmt, clang-format) |
| Stop / Notification / PermissionRequest | `notify.sh` | Terminal bell + Windows toast via the host bridge |

Hooks receive their payload as JSON on stdin and are wired through the
`~/.claude/hooks` symlink, so they work regardless of where the dotfiles repo
is cloned.

## Notifications from devcontainers (Windows, one-time setup)

Containers have no notification path to the host, so `notify.sh` sends one
TCP line to a listener on Windows which renders a native toast.

1. Copy `claude/hooks/windows-toast-bridge.ps1` to `%USERPROFILE%\claude-notify\`.
2. Register it at logon (Windows PowerShell 5.1, not pwsh 7):
   ```
   schtasks /Create /TN "Claude Toast Bridge" /SC ONLOGON /RL LIMITED /F /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File %USERPROFILE%\claude-notify\windows-toast-bridge.ps1"
   ```
3. Test from any container: `printf 'Claude Code\ttest\n' > /dev/tcp/host.docker.internal/47823`
4. For the terminal bell sound, in the **Windows-side** VS Code settings:
   `"accessibility.signals.terminalBell": { "sound": "on" }`

If the toast doesn't arrive, relaunch the bridge with `-BindAny` (some Docker
Desktop builds can't reach host loopback); connections stay restricted to
Docker's address ranges. Toasts from the same project replace each other
instead of stacking.

## Vendored skills

| Skill | Source | License |
|---|---|---|
| `stop-slop` | [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) | MIT |
| `animation-vocabulary`, `review-animations` | [emilkowalski/skills](https://github.com/emilkowalski/skills) | MIT |

## MCP

Only `context7` (live library docs, no API key) is installed globally.
Web search uses the built-in WebSearch / the `web-search` agent (Tavily REST
via `TAVILY_API_KEY` if set); GitHub goes through the `gh` CLI with
`GITHUB_TOKEN`. Project-specific MCP servers belong in the project's
`.mcp.json`, not here.

## Setup — New Machine

```bash
# 1. Clone in WSL
git clone git@github.com:Alexandre-Caby/dotfiles.git ~/dotfiles
bash ~/dotfiles/install.sh

# 2. VSCode settings (one-time)
# Settings → search "dotfiles" → set:
#   Repository: https://github.com/Alexandre-Caby/dotfiles
#   Target Path: ~/dotfiles
#   Install Command: bash ~/dotfiles/install.sh

# 3. Environment variables in WSL (~/.bashrc)
export ANTHROPIC_API_KEY="sk-ant-..."
export GITHUB_TOKEN="ghp_..."
export TAVILY_API_KEY="tvly-..."   # optional
```

Then the one-time Windows toast bridge setup above.

## Notes

- `claude/settings.json` is symlinked, so in-session changes (`/model`,
  `/config`) write back into this repo — review `git diff` before committing,
  they become fleet-wide defaults.
- CI runs the hook test suites, shellcheck, JSON validation, and an
  `install.sh` smoke test on every push.

## License

Personal configuration. MIT. Vendored skills keep their upstream licenses
(see each skill's LICENSE file).
