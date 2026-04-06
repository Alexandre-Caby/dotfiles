#!/bin/bash
# ============================================================
# session-handoff.sh — Generates a session summary for handoff
# Usage:
#   session-handoff.sh           → full summary (stdout)
#   session-handoff.sh --copy    → copies to clipboard (xclip/xsel/pbcopy)
#   session-handoff.sh --save    → writes CONTEXT.md at current project root
# ============================================================

set -e

# ── Colors ──────────────────────────────────────────────────
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

TODAY=$(date '+%Y-%m-%d %H:%M')
SAVE_MODE=false
COPY_MODE=false

for arg in "$@"; do
  case "$arg" in
    --save)  SAVE_MODE=true ;;
    --copy)  COPY_MODE=true ;;
  esac
done

# ── Detect project root ──────────────────────────────────────
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
PROJECT_NAME=$(basename "$PROJECT_ROOT")

# ── Build summary ────────────────────────────────────────────
OUTPUT=""

OUTPUT+="# Session Handoff — $TODAY\n"
OUTPUT+="**Project:** \`$PROJECT_NAME\` (\`$PROJECT_ROOT\`)\n\n"

# Git branch & recent commits
if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null || echo "detached HEAD")
  OUTPUT+="## Git state\n"
  OUTPUT+="**Branch:** \`$BRANCH\`\n\n"
  OUTPUT+="**Recent commits (last 7 days):**\n"
  COMMITS=$(git log --oneline --since="7 days ago" --format="- \`%h\` %s (%ar)" 2>/dev/null || echo "none")
  OUTPUT+="$COMMITS\n\n"

  # Uncommitted changes
  DIRTY=$(git status --short 2>/dev/null)
  if [ -n "$DIRTY" ]; then
    OUTPUT+="**Uncommitted changes:**\n"
    while IFS= read -r line; do
      OUTPUT+="  $line\n"
    done <<< "$DIRTY"
    OUTPUT+="\n"
  else
    OUTPUT+="**Working tree:** clean ✅\n\n"
  fi

  # Recently modified files (last 4h)
  RECENT_FILES=$(find "$PROJECT_ROOT" -type f \
    -newer "$PROJECT_ROOT/.git/FETCH_HEAD" \
    -not -path "*/.git/*" \
    -not -path "*/node_modules/*" \
    -not -path "*/__pycache__/*" \
    -not -path "*/target/*" \
    -not -path "*/.next/*" \
    2>/dev/null | head -20)
  if [ -n "$RECENT_FILES" ]; then
    OUTPUT+="**Recently touched files:**\n"
    while IFS= read -r f; do
      REL=$(realpath --relative-to="$PROJECT_ROOT" "$f" 2>/dev/null || echo "$f")
      OUTPUT+="- \`$REL\`\n"
    done <<< "$RECENT_FILES"
    OUTPUT+="\n"
  fi
fi

# CONTEXT.md check
CONTEXT_FILE="$PROJECT_ROOT/CONTEXT.md"
if [ -f "$CONTEXT_FILE" ]; then
  OUTPUT+="## Existing CONTEXT.md\n"
  OUTPUT+="$(cat "$CONTEXT_FILE")\n\n"
else
  OUTPUT+="## CONTEXT.md\n"
  OUTPUT+="> No CONTEXT.md found — run \`context-keeper\` in Claude Code to generate one.\n\n"
fi

# Prompt for next session
OUTPUT+="## Prompt to paste at next session start\n\n"
OUTPUT+="\`\`\`\n"
OUTPUT+="Resuming work on $PROJECT_NAME (branch: $(git branch --show-current 2>/dev/null || echo 'main')).\n"
if [ -f "$CONTEXT_FILE" ]; then
  NEXT_ACTIONS=$(grep -A5 "Next session: first 3 actions" "$CONTEXT_FILE" 2>/dev/null | tail -4 | grep '^[0-9]' || echo "")
  if [ -n "$NEXT_ACTIONS" ]; then
    OUTPUT+="Next actions:\n$NEXT_ACTIONS\n"
  fi
fi
OUTPUT+="Read CONTEXT.md before starting.\n"
OUTPUT+="\`\`\`\n"

# ── Output ───────────────────────────────────────────────────
printf '%s' "$OUTPUT"

if $SAVE_MODE; then
  printf '%s' "$OUTPUT" > "$CONTEXT_FILE"
  echo ""
  echo -e "${GREEN}✓ Written to $CONTEXT_FILE${RESET}"
fi

if $COPY_MODE; then
  CLIP_CMD=""
  if command -v xclip &>/dev/null; then
    CLIP_CMD="xclip -selection clipboard"
  elif command -v xsel &>/dev/null; then
    CLIP_CMD="xsel --clipboard --input"
  elif command -v pbcopy &>/dev/null; then
    CLIP_CMD="pbcopy"
  elif command -v clip.exe &>/dev/null; then
    CLIP_CMD="clip.exe"
  fi

  if [ -n "$CLIP_CMD" ]; then
    printf '%s' "$OUTPUT" | $CLIP_CMD
    echo -e "${GREEN}✓ Copied to clipboard${RESET}"
  else
    echo -e "${YELLOW}⚠  No clipboard tool found (xclip/xsel/pbcopy/clip.exe)${RESET}"
  fi
fi
