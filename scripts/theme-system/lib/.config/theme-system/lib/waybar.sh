#!/usr/bin/env bash
set -Eeuo pipefail

BASE="$HOME/.config/theme-system/lib"

source "$BASE/core.sh"
source "$BASE/theme.sh"

get_waybar_mode() {
    read_state "$WAYBAR_MODE_FILE" "$DEFAULT_WAYBAR_MODE"
}

set_waybar_mode() {
    local mode="$1"

    case "$mode" in
        informative|minimal) ;;
        *)
            notify "Invalid mode: $mode"
            exit 1
            ;;
    esac

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
