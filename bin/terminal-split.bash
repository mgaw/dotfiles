#!/usr/bin/env -S usage bash
#USAGE about "Split the current terminal to the right and run the given command there. Focus stays on the current terminal."
#USAGE arg "<command>" help="Command to run in the new split"

if [[ -n ${CMUX_WORKSPACE_ID:-} ]]; then
    cmux new-split right --focus false --command "$usage_command" >/dev/null
else
    ghostty-split "$usage_command"
fi
