#!/usr/bin/env bash
#
# @brief Test suite for notify.sh.
#
# Uses a throwaway python3 TCP listener as a stand-in for the Windows bridge,
# so the wire format is asserted end to end without a Windows host.
#
# Usage: ./notify.test.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
readonly NOTIFY="${SCRIPT_DIR}/notify.sh"
readonly TEST_PORT=47899
readonly LISTENER_READY_TIMEOUT_SECONDS=5

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

tests_run=0
tests_failed=0

##
# @brief Asserts two strings are equal.
# @param $1 Test name
# @param $2 Expected value
# @param $3 Actual value
##
assert_equals() {
  local name="$1" expected="$2" actual="$3"
  tests_run=$((tests_run + 1))
  if [ "$expected" = "$actual" ]; then
    printf '  ok   %s\n' "$name"
  else
    tests_failed=$((tests_failed + 1))
    printf '  FAIL %s\n       expected: %q\n       actual:   %q\n' \
      "$name" "$expected" "$actual"
  fi
}

##
# @brief Asserts a string contains a substring.
# @param $1 Test name
# @param $2 Expected substring
# @param $3 Actual value
##
assert_contains() {
  local name="$1" needle="$2" haystack="$3"
  tests_run=$((tests_run + 1))
  if [[ "$haystack" == *"$needle"* ]]; then
    printf '  ok   %s\n' "$name"
  else
    tests_failed=$((tests_failed + 1))
    printf '  FAIL %s\n       expected substring: %q\n       actual: %q\n' \
      "$name" "$needle" "$haystack"
  fi
}

##
# @brief Runs notify.sh against a one-shot listener and returns what it received.
# @param $1 JSON payload piped to the hook
# @param $2 Path the bell is redirected to
# @return Received line on stdout, empty if nothing arrived
##
capture_bridge_line() {
  local payload="$1" bell_target="$2"
  local received="${WORK_DIR}/received" ready="${WORK_DIR}/ready"
  rm -f "$received" "$ready"

  RECEIVED_PATH="$received" READY_PATH="$ready" LISTEN_PORT="$TEST_PORT" \
    python3 -c '
import os, socket
server = socket.socket()
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server.bind(("127.0.0.1", int(os.environ["LISTEN_PORT"])))
server.listen(1)
open(os.environ["READY_PATH"], "w").close()
connection, _ = server.accept()
with open(os.environ["RECEIVED_PATH"], "wb") as sink:
    sink.write(connection.recv(4096))
connection.close()
server.close()
' &
  local listener_pid=$!

  local waited=0
  while [ ! -f "$ready" ] && [ "$waited" -lt "$LISTENER_READY_TIMEOUT_SECONDS" ]; do
    sleep 0.2
    waited=$((waited + 1))
  done

  printf '%s' "$payload" | CLAUDE_NOTIFY_HOST=127.0.0.1 \
    CLAUDE_NOTIFY_PORT="$TEST_PORT" \
    CLAUDE_NOTIFY_TTY="$bell_target" \
    CLAUDE_PROJECT_DIR=/workspaces/demo-project \
    bash "$NOTIFY"

  wait "$listener_pid" 2>/dev/null
  cat "$received" 2>/dev/null
}

printf 'notify.sh\n'

# Stop delivers title, body and a bell.
bell_file="${WORK_DIR}/bell-stop"
: >"$bell_file"
line="$(capture_bridge_line '{"hook_event_name":"Stop","session_id":"abc"}' "$bell_file")"
assert_equals 'Stop sends "<title>\t<body>"' \
  "Claude Code — demo-project"$'\t'"Task complete" \
  "${line%$'\n'}"
assert_equals 'Stop rings the bell once' \
  '\a' \
  "$(od -c <"$bell_file" | head -1 | awk '{print $2}')"

# Notification carries the message and stays silent.
bell_file="${WORK_DIR}/bell-notification"
: >"$bell_file"
line="$(capture_bridge_line \
  '{"hook_event_name":"Notification","message":"Claude needs your permission"}' \
  "$bell_file")"
assert_contains 'Notification forwards the message field' \
  'Claude needs your permission' "$line"
assert_equals 'Notification does not ring the bell' \
  0 "$(wc -c <"$bell_file")"

# Notification without a message falls back.
line="$(capture_bridge_line '{"hook_event_name":"Notification"}' "${WORK_DIR}/bell-fallback")"
assert_contains 'Notification without message falls back' 'Attention required' "$line"

# PermissionRequest names the tool.
line="$(capture_bridge_line \
  '{"hook_event_name":"PermissionRequest","tool_name":"Bash"}' \
  "${WORK_DIR}/bell-permission")"
assert_contains 'PermissionRequest names the tool' 'Permission required: Bash' "$line"

# A tab inside the message must not be mistaken for the field separator.
line="$(capture_bridge_line \
  "$(printf '{"hook_event_name":"Notification","message":"line one\tline two"}')" \
  "${WORK_DIR}/bell-sanitize")"
assert_equals 'Tabs in the message are sanitized to spaces' \
  "Claude Code — demo-project"$'\t'"line one line two" \
  "${line%$'\n'}"

# Unreachable bridge must not fail or stall the turn.
start_seconds="$SECONDS"
printf '%s' '{"hook_event_name":"Stop"}' | CLAUDE_NOTIFY_HOST=127.0.0.1 \
  CLAUDE_NOTIFY_PORT=1 \
  CLAUDE_NOTIFY_TTY="${WORK_DIR}/bell-down" \
  bash "$NOTIFY"
assert_equals 'Unreachable bridge exits 0' 0 "$?"
tests_run=$((tests_run + 1))
if [ $((SECONDS - start_seconds)) -le 3 ]; then
  printf '  ok   Unreachable bridge returns within the timeout\n'
else
  tests_failed=$((tests_failed + 1))
  printf '  FAIL Unreachable bridge returns within the timeout\n'
fi

# Malformed payloads must not crash.
printf '%s' 'not json at all' | CLAUDE_NOTIFY_HOST=127.0.0.1 \
  CLAUDE_NOTIFY_PORT=1 \
  CLAUDE_NOTIFY_TTY="${WORK_DIR}/bell-malformed" \
  bash "$NOTIFY"
assert_equals 'Malformed payload exits 0' 0 "$?"

printf '\n%d run, %d failed\n' "$tests_run" "$tests_failed"
[ "$tests_failed" -eq 0 ]
