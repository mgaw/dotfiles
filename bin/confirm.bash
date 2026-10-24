#!/usr/bin/env -S usage bash
#USAGE arg "<command>" help="Command to run after confirmation"

set -euo pipefail

read -rp "$usage_command [Yn] " reply
if [[ $reply != "n" ]]; then
    eval "$usage_command"
fi
