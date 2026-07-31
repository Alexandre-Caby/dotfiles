#!/bin/bash
# ============================================================
# Dotfiles install script — Alexandre
# Executed automatically by VSCode Dev Containers Dotfiles
# Compatible: Debian/Ubuntu (apt), Alpine (apk), RHEL (yum)
# ============================================================

set -uo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_CONFIG="$DOTFILES_DIR/claude"

# Package installs need root; devcontainers usually run as a non-root user.
SUDO=""
if [ "$(id -u)" -ne 0 ] && command -v sudo &>/dev/null; then
  SUDO="sudo -n"
fi

##
# @brief Installs packages with the available package manager, non-fatally.
# @param $@ Package names
##
install_packages() {
  if command -v apt-get &>/dev/null; then
    $SUDO apt-get update -qq && $SUDO apt-get install -y -qq "$@"
  elif command -v apk &>/dev/null; then
    $SUDO apk add --no-cache "$@"
  elif command -v yum &>/dev/null; then
    $SUDO yum install -y -q "$@"
  else
    return 1
  fi
}

echo "🔧 Installing dotfiles from $DOTFILES_DIR"

# ── 1. Symlink Claude config into ~/.claude ──────────────────
# First and unconditional: everything else is best-effort on top.
echo "  → Symlinking ~/.claude items"
if [ -d "$HOME/.claude" ] && [ -L "$HOME/.claude" ]; then
  rm "$HOME/.claude"
fi
mkdir -p "$HOME/.claude"
for item in CLAUDE.md settings.json agents commands skills hooks; do
  ln -sfn "$CLAUDE_CONFIG/$item" "$HOME/.claude/$item"
done
chmod +x "$CLAUDE_CONFIG/hooks/"*.sh 2>/dev/null || true
echo "  ✓ ~/.claude items symlinked from $CLAUDE_CONFIG"

# ── 2. curl (required for the Claude Code installer) ─────────
if ! command -v curl &>/dev/null; then
  echo "  → Installing curl"
  install_packages curl ca-certificates || echo "  ⚠  curl install failed — Claude Code install may fail"
fi

# ── 3. tmux (optional, used by tmux workflows) ───────────────
if ! command -v tmux &>/dev/null; then
  install_packages tmux &>/dev/null && echo "  ✓ tmux installed" || echo "  ℹ  tmux not available (optional)"
fi

# ── 4. Claude Code (native installer, no root needed) ────────
if ! command -v claude &>/dev/null; then
  echo "  → Installing Claude Code (native installer)"
  if curl -fsSL https://claude.ai/install.sh | bash; then
    export PATH="$HOME/.local/bin:$PATH"
    echo "  ✓ Claude Code installed: $(claude --version 2>/dev/null || echo 'restart shell to use')"
  else
    echo "  ✗ Claude Code installation failed"
  fi
else
  echo "  ✓ Claude Code already present: $(claude --version 2>/dev/null)"
fi

# ── 5. MCP: context7 (live library docs, no API key) ─────────
# Needs node for npx; skip silently on images without it rather than
# pulling a full Node.js toolchain just for one MCP.
export PATH="$HOME/.local/bin:$PATH"
if command -v claude &>/dev/null && command -v npx &>/dev/null; then
  if ! claude mcp list 2>/dev/null | grep -q "context7"; then
    claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp 2>/dev/null \
      && echo "  ✓ MCP context7 added" \
      || echo "  ⚠  MCP context7 — failed (ignored)"
  else
    echo "  ✓ MCP context7 already configured"
  fi
else
  echo "  ℹ  MCP context7 skipped (claude or npx missing)"
fi

# ── 6. PATH for local binaries ────────────────────────────────
if ! grep -q '\.local/bin' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.bashrc"
fi

# ── 7. Post-install validation ────────────────────────────────
echo ""
echo "🔍 Validating installation..."
ERRORS=0
for link in CLAUDE.md settings.json agents commands skills hooks; do
  if [ -e "$HOME/.claude/$link" ]; then
    echo "  ✓ ~/.claude/$link"
  else
    echo "  ✗ ~/.claude/$link missing"
    ERRORS=$((ERRORS + 1))
  fi
done
if command -v claude &>/dev/null; then
  echo "  ✓ Claude Code in PATH: $(claude --version 2>/dev/null || echo 'unknown version')"
else
  echo "  ✗ Claude Code not in PATH"
  ERRORS=$((ERRORS + 1))
fi
echo "  ✓ $(ls "$HOME/.claude/agents/"*.md 2>/dev/null | wc -l) agents, $(ls "$HOME/.claude/commands/"*.md 2>/dev/null | wc -l) commands"

echo ""
if [ "$ERRORS" -eq 0 ]; then
  echo "✅ Dotfiles installed — 0 errors"
else
  echo "⚠  Dotfiles installed with $ERRORS error(s) — check above"
fi
