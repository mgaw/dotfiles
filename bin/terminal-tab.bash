#!/usr/bin/env -S usage bash
#USAGE about "Open a new tab in the current terminal (cmux or Ghostty) and run the given command in it."
#USAGE flag "-b --background" help="Keep the current tab focused"
#USAGE flag "-c --confirm" help="Ask for confirmation before opening the tab"
#USAGE arg "<command>" help="Command to run in the new tab"
#USAGE arg "[second-command]" help="Command to run in a split pane next to it"

set -euo pipefail

background=${usage_background:-false}
confirm=${usage_confirm:-false}
command1=$usage_command
command2=${usage_second_command:-}

if $confirm; then
    prompt=$command1
    if [[ -n $command2 ]]; then
        prompt+=" --- $command2"
    fi
    read -rp "$prompt [Yn] " reply
    if [[ $reply == "n" ]]; then
        exit 0
    fi
fi

cmux_tab() {
    local focus=true
    if $background; then
        focus=false
    fi

    local surface
    surface=$(cmux --json --id-format uuids new-surface \
        --working-directory "$PWD" --command "$command1" --focus "$focus" |
        jq -r .surface_id)

    if [[ -n $command2 ]]; then
        cmux new-split right --surface "$surface" --command "$command2" --focus false >/dev/null
    fi
}

if [[ -n ${CMUX_WORKSPACE_ID:-} ]]; then
    cmux_tab
else
    ghostty-tab "$command1" "$command2" "$background"
fi
