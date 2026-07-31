#!/usr/bin/env bash
#
# @brief PreToolUse guard: blocks destructive shell commands and secret reads.
#
# Receives the hook payload as JSON on stdin (Claude Code's hook contract) and
# exits 2 with a reason on stderr to block the tool call, 0 to allow it.
#
# Defense in depth behind permissions.deny: deny rules match command prefixes,
# so `cd /tmp && rm -rf /` slips past them — this guard matches anywhere in the
# command line.
#
# Fails open when python3 is missing so exotic images never lose Bash entirely;
# permissions.deny remains the primary layer.

set -uo pipefail

command -v python3 >/dev/null 2>&1 || exit 0

# The program goes through -c, not stdin: stdin must stay free for the payload.
GUARD_PROGRAM=$(cat <<'PYTHON_GUARD'
import json
import re
import sys

BLOCKED_COMMAND_PATTERNS = [
    ("rm -rf /", "Destructive command detected"),
    ("rm -fr /", "Destructive command detected"),
    ("> /dev/sd", "Raw disk write detected"),
    ("mkfs", "Filesystem format detected"),
    (":(){:|:&};:", "Fork bomb detected"),
    ("chmod -R 777", "Recursive chmod 777 is dangerous"),
    ("chmod 777 /", "chmod 777 on root paths is dangerous"),
]

# Shell readers that would expose secret files; Read tool paths are covered by
# permissions.deny Read rules, this catches the Bash escape hatch.
SECRET_READERS = ["cat", "head", "tail", "less", "more", "strings", "xxd", "od"]
SECRET_MARKERS = [".env", "credentials", "secret", "id_rsa", "id_ed25519", ".pem"]
SECRET_SAFE_MARKERS = [".env.example", ".env.template", ".env.sample"]


def block(reason: str) -> None:
    print(f"BLOCKED: {reason}", file=sys.stderr)
    sys.exit(2)


def reads_secret_file(command: str) -> bool:
    # A reader only owns the arguments of its own command segment; without the
    # split, `head -5 x; echo "(end secrets)"` would false-positive.
    segments = re.split(r"[;|&\n]+", command)
    for segment in segments:
        tokens = segment.split()
        for index, token in enumerate(tokens):
            if token not in SECRET_READERS:
                continue
            for argument in tokens[index + 1 :]:
                lowered = argument.lower()
                if any(safe in lowered for safe in SECRET_SAFE_MARKERS):
                    continue
                if any(marker in lowered for marker in SECRET_MARKERS):
                    return True
    return False


try:
    payload = json.load(sys.stdin)
except (json.JSONDecodeError, UnicodeDecodeError):
    sys.exit(0)

if payload.get("tool_name") != "Bash":
    sys.exit(0)

command = payload.get("tool_input", {}).get("command", "")

for pattern, reason in BLOCKED_COMMAND_PATTERNS:
    if pattern in command:
        block(reason)

if reads_secret_file(command):
    block(
        "Reading secret files via shell is not allowed — "
        "use environment variables, or read the .example variant"
    )

sys.exit(0)
PYTHON_GUARD
)

python3 -c "$GUARD_PROGRAM"
exit $?
