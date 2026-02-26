#!/usr/bin/env bash
set -Eeuo pipefail

CORE="$HOME/.config/theme-system/lib/core.sh"
source "$CORE"

detect_themes() {
    shopt -s nullglob
    for dir in "$THEME_ROOT"/*; do
        [[ -d "$dir" ]] && basename "$dir"
    done | sort -V
    shopt -u nullglob
}

theme_exists() {
    local t="$1"
    detect_themes | grep -qx "$t"
}

get_theme() {
    local theme
    theme="$(read_state "$THEME_FILE" "$DEFAULT_THEME")"

    if theme_exists "$theme"; then
        echo "$theme"
    else
        write_state "$THEME_FILE" "$DEFAULT_THEME"
        echo "$DEFAULT_THEME"
    fi
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
    mapfile -t themes < <(detect_themes | sort -V)
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
