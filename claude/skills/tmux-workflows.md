---
description: tmux session management patterns for Claude Code agents and dev workflows
globs:
  - "**/*"
---

# tmux Workflows for Claude Code

## When to Use tmux

- Running long-running processes in background (builds, tests, servers)
- Parallel service management (dev server + test watcher + log tail)
- Preserving output from background tasks for later review
- Agent team workflows needing isolated execution contexts

## Session Management

### Create a named session (detached)
```bash
tmux new-session -d -s <name> '<command>'
```

### List active sessions
```bash
tmux list-sessions
```

### Attach to a session
```bash
tmux attach-session -t <name>
```

### Kill a session
```bash
tmux kill-session -t <name>
```

## Dev Workflow Patterns

### Background build
```bash
tmux new-session -d -s build 'npm run build 2>&1 | tee /tmp/build.log'
```

### Parallel services
```bash
tmux new-session -d -s dev 'npm run dev'
tmux new-session -d -s test 'npm run test -- --watch'
tmux new-session -d -s logs 'tail -f /var/log/app.log'
```

### Capture output from a background session
```bash
tmux capture-pane -t <session> -p
```

### Send a command to a running session
```bash
tmux send-keys -t <session> '<command>' Enter
```

## Agent Team Integration

When Claude Code agents need to run long processes:
1. Create a named tmux session for each long-running task
2. Use `tmux capture-pane -t <session> -p` to read output without interrupting
3. Kill sessions when work is complete to avoid resource leaks

### Checking if a process is still running
```bash
tmux has-session -t <name> 2>/dev/null && echo "running" || echo "stopped"
```

## WSL2 / Devcontainer Notes

- tmux must be installed in the container (`apt-get install -y tmux`)
- The `install.sh` dotfiles script handles this automatically
- tmux sessions do not persist across container rebuilds
- Use `tmux` inside the container, not from the Windows host
