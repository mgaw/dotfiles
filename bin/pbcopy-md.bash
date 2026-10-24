#!/usr/bin/env -S usage bash
#USAGE about "Copy Markdown from stdin as HTML with a plain-text fallback."

set -euo pipefail

markdown=$(cat)
html=$(pandoc -f gfm -t html --wrap=none <<<"$markdown")

pbcopy-html "$html" "$markdown"
