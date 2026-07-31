#!/usr/bin/env bash
#
# @brief Forwards Claude Code hook events to the Windows host toast listener.
#
# Runs inside devcontainers, where no notification daemon exists and Windows
# interop is unreachable. Transport is a raw TCP line to the host bridge
# (see windows-toast-bridge.ps1), written with the bash /dev/tcp builtin so the
# hook stays dependency-free across every base image.
#
# Never fails a turn: unreachable bridge, missing tty and malformed payloads all
# exit 0.
#
# Environment overrides (used by the test suite):
#   CLAUDE_NOTIFY_HOST     bridge host        (default: host.docker.internal)
#   CLAUDE_NOTIFY_PORT     bridge port        (default: 47823)
#   CLAUDE_NOTIFY_TIMEOUT  connect timeout, s (default: 2)
#   CLAUDE_NOTIFY_TTY      bell target        (default: /dev/tty)

set -uo pipefail

readonly BRIDGE_HOST="${CLAUDE_NOTIFY_HOST:-host.docker.internal}"
readonly BRIDGE_PORT="${CLAUDE_NOTIFY_PORT:-47823}"
readonly BRIDGE_TIMEOUT_SECONDS="${CLAUDE_NOTIFY_TIMEOUT:-2}"
readonly BELL_TARGET="${CLAUDE_NOTIFY_TTY:-/dev/tty}"
readonly FIELD_SEPARATOR=$'\t'

##
# @brief Extracts a top-level string field from the hook JSON payload.
# @param $1 Field name
# @param $2 Raw JSON payload
# @return Field value on stdout, empty if absent
#
# grep/sed rather than jq: jq is absent from most devcontainer images. Values
# containing escaped quotes are truncated at the escape, which is acceptable for
# the short fields consumed here.
##
json_field() {
  local key="$1" payload="$2"
  printf '%s' "$payload" |
    grep -o "\"${key}\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" |
    head -1 |
    sed 's/^[^:]*:[[:space:]]*"//; s/"$//'
}

##
# @brief Collapses characters that would corrupt the line-based wire format.
# @param $1 Raw text
# @return Sanitized single-line text on stdout
##
sanitize_line() {
  printf '%s' "$1" | tr '\t\r\n' '   '
}

##
# @brief Sends one notification line to the host bridge.
# @param $1 Notification title
# @param $2 Notification body
#
# Silent no-op when the bridge is down so containers on hosts without the
# listener are unaffected.
##
send_to_bridge() {
  NOTIFY_TITLE="$(sanitize_line "$1")" \
  NOTIFY_BODY="$(sanitize_line "$2")" \
  NOTIFY_HOST="$BRIDGE_HOST" \
  NOTIFY_PORT="$BRIDGE_PORT" \
  NOTIFY_SEPARATOR="$FIELD_SEPARATOR" \
    timeout "$BRIDGE_TIMEOUT_SECONDS" bash -c \
      'printf "%s%s%s\n" "$NOTIFY_TITLE" "$NOTIFY_SEPARATOR" "$NOTIFY_BODY" \
         >"/dev/tcp/$NOTIFY_HOST/$NOTIFY_PORT"' 2>/dev/null || true
}

##
# @brief Rings the terminal bell, which VS Code renders on the Windows host.
#
# Only used for Stop: Claude Code's own preferredNotifChannel=terminal_bell
# already covers attention events, and belling twice would double-beep.
#
# Hooks run without a controlling terminal, so /dev/tty is usually absent and
# the parent's terminal is used instead. Braces keep the failed redirection
# quiet, which a redirection on printf alone would not.
##
ring_bell() {
  { printf '\a' >>"$BELL_TARGET"; } 2>/dev/null && return 0

  local parent_stderr="/proc/${PPID}/fd/2"
  if [ -c "$parent_stderr" ]; then
    { printf '\a' >>"$parent_stderr"; } 2>/dev/null || true
  fi
  return 0
}

main() {
  local payload event project title body
  payload="$(cat)"
  event="$(json_field hook_event_name "$payload")"

  project="$(basename "${CLAUDE_PROJECT_DIR:-$(json_field cwd "$payload")}")"
  [ -n "$project" ] || project="session"
  title="Claude Code — ${project}"

  case "$event" in
    Stop)
      body="Task complete"
      ring_bell
      ;;
    Notification)
      body="$(json_field message "$payload")"
      [ -n "$body" ] || body="Attention required"
      ;;
    PermissionRequest)
      local tool
      tool="$(json_field tool_name "$payload")"
      body="Permission required${tool:+: $tool}"
      ;;
    *)
      body="${event:-Event}"
      ;;
  esac

  send_to_bridge "$title" "$body"
}

main
exit 0
