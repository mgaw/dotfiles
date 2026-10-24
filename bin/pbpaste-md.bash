#!/usr/bin/env -S usage bash
#USAGE about "Print clipboard HTML as Markdown."

set -euo pipefail

pbpaste-html |
    pandoc -f html -t gfm-raw_html --wrap=none
