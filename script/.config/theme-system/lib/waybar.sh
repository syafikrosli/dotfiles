#!/usr/bin/env bash
set -Eeuo pipefail

source "$HOME/.config/theme-system/lib/core.sh"
source "$HOME/.config/theme-system/lib/theme.sh"

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
    local base="$WAYBAR_DIR/style-base-$theme.css"
    local layout="$WAYBAR_DIR/style-$mode.css"
    local final="$WAYBAR_DIR/style.css"

    # safety checks (ADD THIS PART)
    [[ -f "$config" ]] || { notify "Waybar config missing: $config"; return 1; }
    [[ -f "$base" ]] || { notify "Waybar theme missing: $base"; return 1; }
    [[ -f "$layout" ]] || { notify "Waybar layout missing: $layout"; return 1; }

    ln -sfn "$config" "$WAYBAR_DIR/config"

    {
        echo "/* generated file */"
        echo "/* theme: $theme | mode: $mode */"
        cat "$base"
        echo
        cat "$layout"
    } > "$final"

    systemctl --user restart waybar.service 2>/dev/null || true
}
