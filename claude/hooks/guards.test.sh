#!/usr/bin/env bash
#
# @brief Test suite for pre-guard.sh and post-format.sh.
#
# Usage: ./guards.test.sh

set -uo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PRE_GUARD="${SCRIPT_DIR}/pre-guard.sh"
readonly POST_FORMAT="${SCRIPT_DIR}/post-format.sh"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

tests_run=0
tests_failed=0

##
# @brief Runs pre-guard.sh with a Bash command payload, asserts the exit code.
# @param $1 Test name
# @param $2 Expected exit code (0 allow, 2 block)
# @param $3 Shell command placed in the payload
##
assert_guard() {
  local name="$1" expected="$2" shell_command="$3"
  tests_run=$((tests_run + 1))

  SHELL_COMMAND="$shell_command" python3 -c '
import json, os
print(json.dumps({
    "hook_event_name": "PreToolUse",
    "tool_name": "Bash",
    "tool_input": {"command": os.environ["SHELL_COMMAND"]},
}))
' | bash "$PRE_GUARD" 2>"${WORK_DIR}/guard-stderr"
  local actual=$?

  if [ "$actual" -eq "$expected" ]; then
    printf '  ok   %s\n' "$name"
  else
    tests_failed=$((tests_failed + 1))
    printf '  FAIL %s\n       expected exit %s, got %s (stderr: %s)\n' \
      "$name" "$expected" "$actual" "$(cat "${WORK_DIR}/guard-stderr")"
  fi
}

printf 'pre-guard.sh\n'

assert_guard 'allows ordinary commands' 0 'git status && ls -la'
assert_guard 'allows rm on a project path' 0 'rm -rf ./node_modules'
assert_guard 'blocks rm -rf / anywhere in the line' 2 'cd /tmp && rm -rf /'
assert_guard 'blocks argument-swapped rm -fr /' 2 'rm -fr /'
assert_guard 'blocks raw disk writes' 2 'echo x > /dev/sda1'
assert_guard 'blocks mkfs' 2 'mkfs.ext4 /dev/sdb'
assert_guard 'blocks recursive chmod 777' 2 'chmod -R 777 .'
assert_guard 'blocks cat .env' 2 'cat .env'
assert_guard 'blocks piped secret read' 2 'cat /app/.env.production | grep KEY'
assert_guard 'blocks head on credentials' 2 'head -5 ~/.aws/credentials'
assert_guard 'blocks strings on a key file' 2 'strings ~/.ssh/id_rsa'
assert_guard 'allows cat .env.example' 0 'cat .env.example'
assert_guard 'allows the word secret outside a reader' 0 'grep -rn secret_rotation src/'
assert_guard 'allows secret-words in a later command segment' 0 \
  'grep -rn pattern . | head -10; echo "(end secrets scan)"'
assert_guard 'still blocks a secret read in a later segment' 2 \
  'ls -la; cat .env'

# Non-Bash payloads and garbage input pass through.
tests_run=$((tests_run + 1))
printf '{"tool_name":"Read","tool_input":{"file_path":"/x/.env"}}' | bash "$PRE_GUARD"
if [ $? -eq 0 ]; then
  printf '  ok   ignores non-Bash tools (Read is covered by permissions.deny)\n'
else
  tests_failed=$((tests_failed + 1))
  printf '  FAIL ignores non-Bash tools\n'
fi

tests_run=$((tests_run + 1))
printf 'not json' | bash "$PRE_GUARD"
if [ $? -eq 0 ]; then
  printf '  ok   malformed payload exits 0\n'
else
  tests_failed=$((tests_failed + 1))
  printf '  FAIL malformed payload exits 0\n'
fi

printf 'post-format.sh\n'

##
# @brief Runs post-format.sh with a Write payload for the given file.
# @param $1 File path placed in the payload
##
run_formatter() {
  TARGET_FILE="$1" python3 -c '
import json, os
print(json.dumps({
    "hook_event_name": "PostToolUse",
    "tool_name": "Write",
    "tool_input": {"file_path": os.environ["TARGET_FILE"]},
}))
' | bash "$POST_FORMAT"
}

# A stub gofmt on PATH proves dispatch reaches the right formatter.
STUB_BIN="${WORK_DIR}/bin"
mkdir -p "$STUB_BIN"
printf '#!/bin/sh\necho "formatted:$2" > "%s/gofmt-called"\n' "$WORK_DIR" >"${STUB_BIN}/gofmt"
chmod +x "${STUB_BIN}/gofmt"

go_file="${WORK_DIR}/sample.go"
printf 'package main\n' >"$go_file"
PATH="${STUB_BIN}:$PATH" run_formatter "$go_file"
tests_run=$((tests_run + 1))
if [ "$(cat "${WORK_DIR}/gofmt-called" 2>/dev/null)" = "formatted:${go_file}" ]; then
  printf '  ok   dispatches .go files to gofmt\n'
else
  tests_failed=$((tests_failed + 1))
  printf '  FAIL dispatches .go files to gofmt\n'
fi

tests_run=$((tests_run + 1))
run_formatter "${WORK_DIR}/missing.py"
if [ $? -eq 0 ]; then
  printf '  ok   missing file exits 0\n'
else
  tests_failed=$((tests_failed + 1))
  printf '  FAIL missing file exits 0\n'
fi

tests_run=$((tests_run + 1))
run_formatter "${WORK_DIR}/notes.txt"
if [ $? -eq 0 ]; then
  printf '  ok   unknown extension exits 0\n'
else
  tests_failed=$((tests_failed + 1))
  printf '  FAIL unknown extension exits 0\n'
fi

printf '\n%d run, %d failed\n' "$tests_run" "$tests_failed"
[ "$tests_failed" -eq 0 ]
