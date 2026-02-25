#!/usr/bin/env bash
set -Eeuo pipefail

CORE="$HOME/.config/theme-system/lib/core.sh"
[[ -f "$CORE" ]] || {
    echo "Missing core library: $CORE" >&2
    exit 1
}
source "$CORE"

detect_themes() {
    shopt -s nullglob
    local file name

    for file in "$WAYBAR_DIR"/style-base-*.css; do
        name="${file##*/}"
        name="${name#style-base-}"
        name="${name%.css}"
        printf '%s\n' "$name"
    done

    shopt -u nullglob
}

theme_exists() {
    local t="$1"
    detect_themes | grep -qx "$t"
}

get_theme() {
    read_state "$THEME_FILE" "$DEFAULT_THEME"
}

set_theme() {
    local theme="$1"

    if ! theme_exists "$theme"; then
        notify "Theme not found: $theme"
        exit 1
    fi

    write_state "$THEME_FILE" "$theme"
}

toggle_theme() {
    mapfile -t themes < <(detect_themes)
    local current next

    current="$(get_theme)"

    for i in "${!themes[@]}"; do
        if [[ "${themes[$i]}" == "$current" ]]; then
            next="${themes[$(( (i+1) % ${#themes[@]} ))]}"
            set_theme "$next"
            return
        fi
    done

    set_theme "$DEFAULT_THEME"
}
