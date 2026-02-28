# shellcheck shell=bash
run_if_changed() {
    local watched="$1"
    shift
    local -a cmd=("$@")

    watch_file "$watched"

    local hash
    hash="$(shasum "$watched" 2>/dev/null || true)"
    local hash_file=".direnv/${watched}.hash"

    if [[ ! -f "$hash_file" || "$hash" != "$(cat "$hash_file")" ]]; then
        mkdir -p .direnv
        "${cmd[@]}" && echo "$hash" >"$hash_file"
    fi
}
