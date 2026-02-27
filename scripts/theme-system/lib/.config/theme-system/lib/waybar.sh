#!/usr/bin/env bash
source "$HOME/.config/theme-system/lib/core.sh"

build_waybar_css() {
    local mode
    mode=$(cat "$WAYBAR_MODE_STATE")

    cat \
        "$WAYBAR_DIR/style-base.css" \
        "$WAYBAR_DIR/style-$mode.css" \
        > "$WAYBAR_DIR/style.css"
}
