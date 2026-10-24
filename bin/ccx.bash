#!/usr/bin/env -S usage bash
#USAGE about "Enter a prompt in nvim, then run claude with it here and codex with it in a terminal split to the right."

set -euo pipefail

file=$(mktemp -d)/prompt.md
nvim "$file" || exit "$?"
if [ ! -s "$file" ]; then
    echo 'No prompt entered'
    exit 1
fi
terminal-split "codex \"\$(cat \"$file\")\""
claude <"$file"
