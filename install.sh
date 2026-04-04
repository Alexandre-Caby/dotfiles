#!/bin/bash
# ============================================================
# Dotfiles install script — Alexandre
# Exécuté automatiquement par VSCode Dev Containers Dotfiles
# Compatible : Debian/Ubuntu (apt), Alpine (apk), images slim
# ============================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_CONFIG="$DOTFILES_DIR/claude"

echo "🔧 Installation des dotfiles depuis $DOTFILES_DIR"

# ── 1. Symlink ~/.claude → dotfiles/claude ─────────────────
echo "  → Symlink ~/.claude"
if [ -d "$HOME/.claude" ] && [ ! -L "$HOME/.claude" ]; then
  # Backup si dossier existant non-symlink
  mv "$HOME/.claude" "$HOME/.claude.backup.$(date +%s)"
  echo "  ⚠  Ancien ~/.claude sauvegardé"
fi
ln -sf "$CLAUDE_CONFIG" "$HOME/.claude"
echo "  ✓ ~/.claude → $CLAUDE_CONFIG"

# ── 2. Installer curl si absent ────────────────────────────
if ! command -v curl &>/dev/null; then
  echo "  → Installation de curl"
  if command -v apt-get &>/dev/null; then
    apt-get update -qq && apt-get install -y -qq curl ca-certificates
  elif command -v apk &>/dev/null; then
    apk add --no-cache curl ca-certificates
  elif command -v yum &>/dev/null; then
    yum install -y -q curl ca-certificates
  else
    echo "  ✗ Gestionnaire de paquets non reconnu — installer curl manuellement"
    exit 1
  fi
fi

# ── 3. Installer Node.js si absent (requis pour les MCP) ───
if ! command -v node &>/dev/null; then
  echo "  → Installation de Node.js (LTS)"
  if command -v apt-get &>/dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - 2>/dev/null
    apt-get install -y -qq nodejs
  elif command -v apk &>/dev/null; then
    apk add --no-cache nodejs npm
  elif command -v yum &>/dev/null; then
    curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - 2>/dev/null
    yum install -y nodejs
  fi
  echo "  ✓ Node.js $(node --version 2>/dev/null)"
fi

# ── 4. Installer Claude Code ───────────────────────────────
if ! command -v claude &>/dev/null; then
  echo "  → Installation de Claude Code via npm"
  npm install -g @anthropic-ai/claude-code 2>/dev/null && \
    echo "  ✓ Claude Code installé : $(claude --version 2>/dev/null || echo 'version inconnue')" || \
    echo "  ✗ Échec installation Claude Code (vérifier npm)"
  # Ajouter au PATH courant si nécessaire
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "  ✓ Claude Code déjà présent : $(claude --version 2>/dev/null)"
fi

# ── 5. Installer les MCP servers globaux ───────────────────
# (Requiert que Claude Code soit installé et dans le PATH)
export PATH="$HOME/.local/bin:$PATH"

if command -v claude &>/dev/null; then
  echo "  → Configuration des MCP servers globaux"

  # Context7 — Documentation live des librairies (toujours actif, pas de clé API)
  if ! claude mcp list 2>/dev/null | grep -q "context7"; then
    claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp 2>/dev/null && \
      echo "  ✓ MCP context7 ajouté" || \
      echo "  ⚠  MCP context7 — échec (ignoré)"
  else
    echo "  ✓ MCP context7 déjà configuré"
  fi

  # Tavily — Web search (requiert TAVILY_API_KEY dans l'environnement)
  if [ -n "$TAVILY_API_KEY" ]; then
    if ! claude mcp list 2>/dev/null | grep -q "tavily"; then
      claude mcp add --scope user tavily \
        -e TAVILY_API_KEY="$TAVILY_API_KEY" \
        -- npx -y @tavily-ai/mcp-server 2>/dev/null && \
        echo "  ✓ MCP tavily ajouté" || \
        echo "  ⚠  MCP tavily — échec (ignoré)"
    else
      echo "  ✓ MCP tavily déjà configuré"
    fi
  else
    echo "  ℹ  MCP tavily ignoré (TAVILY_API_KEY non définie)"
    echo "     → Ajouter TAVILY_API_KEY dans devcontainer.json > remoteEnv"
  fi

  # GitHub MCP — Accès aux repos, PRs, issues (requiert GITHUB_TOKEN)
  if [ -n "$GITHUB_TOKEN" ]; then
    if ! claude mcp list 2>/dev/null | grep -q "github"; then
      claude mcp add --scope user github \
        -e GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN" \
        -- npx -y @modelcontextprotocol/server-github 2>/dev/null && \
        echo "  ✓ MCP github ajouté" || \
        echo "  ⚠  MCP github — échec (ignoré)"
    else
      echo "  ✓ MCP github déjà configuré"
    fi
  else
    echo "  ℹ  MCP github ignoré (GITHUB_TOKEN non défini)"
    echo "     → Ajouter GITHUB_TOKEN dans devcontainer.json > remoteEnv"
  fi

else
  echo "  ⚠  Claude Code non trouvé dans PATH — MCP servers ignorés"
fi

# ── 6. Exposer les scripts dotfiles dans le PATH ───────────
SCRIPTS_DIR="$DOTFILES_DIR/scripts"
if [ -d "$SCRIPTS_DIR" ]; then
  if ! grep -q "dotfiles/scripts" "$HOME/.bashrc" 2>/dev/null; then
    echo "" >> "$HOME/.bashrc"
    echo "# Dotfiles scripts" >> "$HOME/.bashrc"
    echo "export PATH=\"$SCRIPTS_DIR:\$PATH\"" >> "$HOME/.bashrc"
    echo "  ✓ Scripts dotfiles ajoutés au PATH"
  fi
  # Rendre tous les scripts exécutables
  chmod +x "$SCRIPTS_DIR"/*.sh 2>/dev/null || true
fi

# ── 8. Copier les extras shell si applicable ───────────────
if [ -f "$DOTFILES_DIR/config/.bashrc_extra" ]; then
  if ! grep -q "bashrc_extra" "$HOME/.bashrc" 2>/dev/null; then
    echo "" >> "$HOME/.bashrc"
    echo "# Dotfiles extras" >> "$HOME/.bashrc"
    echo "source $DOTFILES_DIR/config/.bashrc_extra" >> "$HOME/.bashrc"
    echo "  ✓ .bashrc_extra ajouté"
  fi
fi

# ── 9. Assurer PATH pour les binaires locaux ───────────────
if ! grep -q '\.local/bin' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

# ── 10. Validation post-install ────────────────────────────
echo ""
echo "🔍 Validation de l'installation..."
ERRORS=0
if [ -L "$HOME/.claude" ]; then
  echo "  ✓ Symlink ~/.claude → $(readlink -f "$HOME/.claude")"
else
  echo "  ✗ Symlink ~/.claude manquant"
  ERRORS=$((ERRORS+1))
fi
if [ -f "$HOME/.claude/CLAUDE.md" ]; then
  echo "  ✓ CLAUDE.md trouvé"
else
  echo "  ✗ CLAUDE.md introuvable"
  ERRORS=$((ERRORS+1))
fi
if [ -f "$HOME/.claude/settings.json" ]; then
  echo "  ✓ settings.json trouvé"
else
  echo "  ✗ settings.json introuvable"
  ERRORS=$((ERRORS+1))
fi
if command -v claude &>/dev/null; then
  echo "  ✓ Claude Code dans PATH : $(claude --version 2>/dev/null || echo 'version inconnue')"
else
  echo "  ✗ Claude Code pas dans PATH"
  ERRORS=$((ERRORS+1))
fi
if [ -d "$HOME/.claude/agents" ]; then
  AGENT_COUNT=$(ls "$HOME/.claude/agents/"*.md 2>/dev/null | wc -l)
  echo "  ✓ $AGENT_COUNT agents disponibles"
else
  echo "  ✗ Dossier agents/ introuvable"
  ERRORS=$((ERRORS+1))
fi
if [ -d "$HOME/.claude/commands" ]; then
  CMD_COUNT=$(ls "$HOME/.claude/commands/"*.md 2>/dev/null | wc -l)
  echo "  ✓ $CMD_COUNT slash commands disponibles"
else
  echo "  ✗ Dossier commands/ introuvable"
  ERRORS=$((ERRORS+1))
fi

echo ""
if [ $ERRORS -eq 0 ]; then
  echo "✅ Dotfiles installés avec succès — 0 erreur"
else
  echo "⚠  Dotfiles installés avec $ERRORS erreur(s) — vérifier ci-dessus"
fi
echo ""
echo "   MCP servers configurés :"
command -v claude &>/dev/null && claude mcp list 2>/dev/null | sed 's/^/     • /' || echo "     (claude non disponible dans ce shell)"
