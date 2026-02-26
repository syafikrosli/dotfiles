#!/usr/bin/env bash
set -Eeuo pipefail

BASE="$HOME/.config/theme-system/lib"

source "$BASE/core.sh"
source "$BASE/theme.sh"

get_waybar_mode() {
    local mode
    mode="$(read_state "$WAYBAR_MODE_FILE" "$DEFAULT_WAYBAR_MODE")"

    if waybar_mode_exists "$mode"; then
        echo "$mode"
        return
    fi

    # fallback to first detected mode
    local first
    first="$(detect_waybar_modes | sort -V | head -n1)"

    if [[ -n "$first" ]]; then
        echo "$first"
    else
        echo "$DEFAULT_WAYBAR_MODE"
    fi
}

detect_waybar_modes() {
    shopt -s nullglob
    for file in "$WAYBAR_DIR"/config-*.jsonc; do
        basename "$file" | sed -E 's/config-(.*)\.jsonc/\1/'
    done
    shopt -u nullglob
}

waybar_mode_exists() {
    local m="$1"
    detect_waybar_modes | grep -qx "$m"
}

set_waybar_mode() {
    local mode="$1"

    if ! waybar_mode_exists "$mode"; then
        notify "Invalid mode: $mode"
        exit 1
    fi

    write_state "$WAYBAR_MODE_FILE" "$mode"
}

apply_waybar() {
    local theme mode
    theme="$(get_theme)"
    mode="$(get_waybar_mode)"

    local config="$WAYBAR_DIR/config-$mode.jsonc"
    local base="$THEME_ROOT/$theme/waybar/style-base-$theme.css"
    local layout="$WAYBAR_DIR/style-$mode.css"
    local final="$WAYBAR_DIR/style.css"

    [[ -f "$config" ]] || { notify "Missing Waybar config"; return 1; }
    [[ -f "$base" ]] || { notify "Missing Waybar theme"; return 1; }
    [[ -f "$layout" ]] || { notify "Missing Waybar layout"; return 1; }

    ln -sfn "$config" "$WAYBAR_DIR/config"

    {
        echo "/* generated file */"
        echo "/* theme: $theme | mode: $mode */"
        cat "$base"
        echo
        cat "$layout"
    } > "$final"

    systemctl --user reload-or-restart waybar.service 2>/dev/null || true
}
