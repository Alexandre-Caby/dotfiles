#!/bin/bash
# ============================================================
# Dotfiles install script — Alexandre
# Executed automatically by VSCode Dev Containers Dotfiles
# Compatible: Debian/Ubuntu (apt), Alpine (apk), images slim
# ============================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_CONFIG="$DOTFILES_DIR/claude"

echo "🔧 Installing dotfiles from $DOTFILES_DIR"

# ── 1. Symlink individual items from dotfiles/claude into ~/.claude ──
echo "  → Symlinking ~/.claude items"
if [ -d "$HOME/.claude" ] && [ ! -L "$HOME/.claude" ]; then
  # Backup existing non-symlink directory
  mv "$HOME/.claude" "$HOME/.claude.backup.$(date +%s)"
  echo "  ⚠  Existing ~/.claude backed up"
fi
mkdir -p "$HOME/.claude"
ln -sf "$CLAUDE_CONFIG/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
ln -sf "$CLAUDE_CONFIG/settings.json" "$HOME/.claude/settings.json"
ln -sf "$CLAUDE_CONFIG/agents" "$HOME/.claude/agents"
ln -sf "$CLAUDE_CONFIG/commands" "$HOME/.claude/commands"
ln -sf "$CLAUDE_CONFIG/skills" "$HOME/.claude/skills"
echo "  ✓ ~/.claude items symlinked from $CLAUDE_CONFIG"

# ── 2. Install curl if absent ────────────────────────────────
if ! command -v curl &>/dev/null; then
  echo "  → Installing curl"
  if command -v apt-get &>/dev/null; then
    apt-get update -qq && apt-get install -y -qq curl ca-certificates
  elif command -v apk &>/dev/null; then
    apk add --no-cache curl ca-certificates
  elif command -v yum &>/dev/null; then
    yum install -y -q curl ca-certificates
  else
    echo "  ✗ Unrecognized package manager — install curl manually"
    exit 1
  fi
fi

# ── 3. Install tmux if absent (optional, for agent workflows) ──
if ! command -v tmux &>/dev/null; then
  echo "  → Installing tmux"
  if command -v apt-get &>/dev/null; then
    apt-get install -y -qq tmux 2>/dev/null || true
  elif command -v apk &>/dev/null; then
    apk add --no-cache tmux 2>/dev/null || true
  elif command -v yum &>/dev/null; then
    yum install -y -q tmux 2>/dev/null || true
  fi
  command -v tmux &>/dev/null && echo "  ✓ tmux installed" || echo "  ℹ  tmux not available (optional)"
fi

# ── 4. Install Node.js if absent (required for MCP) ──────────
if ! command -v node &>/dev/null; then
  echo "  → Installing Node.js (LTS)"
  if command -v apt-get &>/dev/null; then
    SETUP_SCRIPT=$(mktemp)
    curl -fsSL https://deb.nodesource.com/setup_lts.x -o "$SETUP_SCRIPT"
    bash "$SETUP_SCRIPT"
    rm -f "$SETUP_SCRIPT"
    apt-get install -y -qq nodejs
  elif command -v apk &>/dev/null; then
    apk add --no-cache nodejs npm
  elif command -v yum &>/dev/null; then
    SETUP_SCRIPT=$(mktemp)
    curl -fsSL https://rpm.nodesource.com/setup_lts.x -o "$SETUP_SCRIPT"
    bash "$SETUP_SCRIPT"
    rm -f "$SETUP_SCRIPT"
    yum install -y nodejs
  fi
  echo "  ✓ Node.js $(node --version 2>/dev/null)"
fi

# ── 5. Install Claude Code ───────────────────────────────────
if ! command -v claude &>/dev/null; then
  echo "  → Installing Claude Code via npm"
  npm install -g @anthropic-ai/claude-code 2>/dev/null && \
    echo "  ✓ Claude Code installed: $(claude --version 2>/dev/null || echo 'unknown version')" || \
    echo "  ✗ Claude Code installation failed (check npm)"
  # Add to current PATH if needed
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "  ✓ Claude Code already present: $(claude --version 2>/dev/null)"
fi

# ── 6. Install global MCP servers ────────────────────────────
# (Requires Claude Code installed and in PATH)
export PATH="$HOME/.local/bin:$PATH"

if command -v claude &>/dev/null; then
  echo "  → Configuring global MCP servers"

  # Context7 — Live library documentation (always active, no API key)
  if ! claude mcp list 2>/dev/null | grep -q "context7"; then
    claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp 2>/dev/null && \
      echo "  ✓ MCP context7 added" || \
      echo "  ⚠  MCP context7 — failed (ignored)"
  else
    echo "  ✓ MCP context7 already configured"
  fi

  # Tavily — Web search (requires TAVILY_API_KEY in environment)
  if [ -n "$TAVILY_API_KEY" ]; then
    if ! claude mcp list 2>/dev/null | grep -q "tavily"; then
      # Note: -e passes env vars via CLI args (visible in ps).
      # claude mcp add does not yet support --env-file.
      claude mcp add --scope user tavily \
        -e TAVILY_API_KEY="$TAVILY_API_KEY" \
        -- npx -y @tavily-ai/mcp-server 2>/dev/null && \
        echo "  ✓ MCP tavily added" || \
        echo "  ⚠  MCP tavily — failed (ignored)"
    else
      echo "  ✓ MCP tavily already configured"
    fi
  else
    echo "  ℹ  MCP tavily skipped (TAVILY_API_KEY not set)"
    echo "     → Add TAVILY_API_KEY to devcontainer.json > remoteEnv"
  fi

  # GitHub MCP — Repo, PR, issue access (requires GITHUB_TOKEN)
  if [ -n "$GITHUB_TOKEN" ]; then
    if ! claude mcp list 2>/dev/null | grep -q "github"; then
      # Note: -e passes env vars via CLI args (visible in ps).
      # claude mcp add does not yet support --env-file.
      claude mcp add --scope user github \
        -e GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN" \
        -- npx -y @modelcontextprotocol/server-github 2>/dev/null && \
        echo "  ✓ MCP github added" || \
        echo "  ⚠  MCP github — failed (ignored)"
    else
      echo "  ✓ MCP github already configured"
    fi
  else
    echo "  ℹ  MCP github skipped (GITHUB_TOKEN not set)"
    echo "     → Add GITHUB_TOKEN to devcontainer.json > remoteEnv"
  fi

else
  echo "  ⚠  Claude Code not found in PATH — MCP servers skipped"
fi

# ── 7. Expose dotfiles scripts in PATH ───────────────────────
SCRIPTS_DIR="$DOTFILES_DIR/scripts"
if [ -d "$SCRIPTS_DIR" ]; then
  if ! grep -q "dotfiles/scripts" "$HOME/.bashrc" 2>/dev/null; then
    echo "" >> "$HOME/.bashrc"
    echo "# Dotfiles scripts" >> "$HOME/.bashrc"
    echo "export PATH=\"$SCRIPTS_DIR:\$PATH\"" >> "$HOME/.bashrc"
    echo "  ✓ Dotfiles scripts added to PATH"
  fi
  # Make specific scripts executable
  chmod +x "$SCRIPTS_DIR/session-handoff.sh" 2>/dev/null || true
fi

# ── 8. Copy shell extras if applicable ────────────────────────
if [ -f "$DOTFILES_DIR/config/.bashrc_extra" ]; then
  if [ "$(stat -c '%u' "$DOTFILES_DIR/config/.bashrc_extra" 2>/dev/null)" = "$(id -u)" ]; then
    if ! grep -q "bashrc_extra" "$HOME/.bashrc" 2>/dev/null; then
      echo "" >> "$HOME/.bashrc"
      echo "# Dotfiles extras" >> "$HOME/.bashrc"
      echo "source $DOTFILES_DIR/config/.bashrc_extra" >> "$HOME/.bashrc"
      echo "  ✓ .bashrc_extra added"
    fi
  else
    echo "  ⚠  .bashrc_extra skipped — ownership mismatch"
  fi
fi

# ── 9. Ensure PATH for local binaries ─────────────────────────
if ! grep -q '\.local/bin' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

# ── 10. Post-install validation ───────────────────────────────
echo ""
echo "🔍 Validating installation..."
ERRORS=0
if [ -d "$HOME/.claude" ]; then
  echo "  ✓ Directory ~/.claude exists"
else
  echo "  ✗ Directory ~/.claude missing"
  ERRORS=$((ERRORS+1))
fi
if [ -f "$HOME/.claude/CLAUDE.md" ]; then
  echo "  ✓ CLAUDE.md found"
else
  echo "  ✗ CLAUDE.md not found"
  ERRORS=$((ERRORS+1))
fi
if [ -f "$HOME/.claude/settings.json" ]; then
  echo "  ✓ settings.json found"
else
  echo "  ✗ settings.json not found"
  ERRORS=$((ERRORS+1))
fi
if command -v claude &>/dev/null; then
  echo "  ✓ Claude Code in PATH: $(claude --version 2>/dev/null || echo 'unknown version')"
else
  echo "  ✗ Claude Code not in PATH"
  ERRORS=$((ERRORS+1))
fi
if [ -d "$HOME/.claude/agents" ]; then
  AGENT_COUNT=$(ls "$HOME/.claude/agents/"*.md 2>/dev/null | wc -l)
  echo "  ✓ $AGENT_COUNT agents available"
else
  echo "  ✗ agents/ directory not found"
  ERRORS=$((ERRORS+1))
fi
if [ -d "$HOME/.claude/commands" ]; then
  CMD_COUNT=$(ls "$HOME/.claude/commands/"*.md 2>/dev/null | wc -l)
  echo "  ✓ $CMD_COUNT slash commands available"
else
  echo "  ✗ commands/ directory not found"
  ERRORS=$((ERRORS+1))
fi

echo ""
if [ $ERRORS -eq 0 ]; then
  echo "✅ Dotfiles installed successfully — 0 errors"
else
  echo "⚠  Dotfiles installed with $ERRORS error(s) — check above"
fi
echo ""
echo "   Configured MCP servers:"
command -v claude &>/dev/null && claude mcp list 2>/dev/null | sed 's/^/     • /' || echo "     (claude not available in this shell)"
