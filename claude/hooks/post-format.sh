#!/usr/bin/env bash
#
# @brief PostToolUse formatter: runs the matching formatter after Write/Edit.
#
# Receives the hook payload as JSON on stdin and formats the touched file by
# extension. Missing formatters and formatter failures are silent: formatting
# is best-effort and must never fail a turn.

set -uo pipefail

command -v python3 >/dev/null 2>&1 || exit 0

FILE="$(python3 -c '
import json, sys
try:
    payload = json.load(sys.stdin)
except (json.JSONDecodeError, UnicodeDecodeError):
    sys.exit(0)
print(payload.get("tool_input", {}).get("file_path", ""))
')"

[ -n "$FILE" ] && [ -f "$FILE" ] || exit 0

case "$FILE" in
  *.ts | *.tsx | *.js | *.jsx | *.json | *.css)
    command -v npx >/dev/null 2>&1 && npx --yes prettier --write "$FILE" >/dev/null 2>&1
    ;;
  *.py)
    if command -v ruff >/dev/null 2>&1; then
      ruff format "$FILE" >/dev/null 2>&1
    elif command -v black >/dev/null 2>&1; then
      black -q "$FILE" >/dev/null 2>&1
    fi
    ;;
  *.rs)
    command -v rustfmt >/dev/null 2>&1 && rustfmt "$FILE" >/dev/null 2>&1
    ;;
  *.go)
    command -v gofmt >/dev/null 2>&1 && gofmt -w "$FILE" >/dev/null 2>&1
    ;;
  *.c | *.h | *.cpp | *.hpp)
    command -v clang-format >/dev/null 2>&1 && clang-format -i "$FILE" >/dev/null 2>&1
    ;;
esac

exit 0
