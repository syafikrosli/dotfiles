#!/usr/bin/env bash

source "$HOME/.config/theme-system/lib/core.sh"

build_waybar_css() {
    local mode
    mode=$(cat "$WAYBAR_MODE_STATE" 2>/dev/null || echo "informative")

    [ -z "$mode" ] && mode="informative"

    cat \
        "$WAYBAR_DIR/style-base.css" \
        "$WAYBAR_DIR/style-$mode.css" \
        > "$WAYBAR_DIR/style.css"
}

set_waybar_mode() {
    local mode="$1"

    if [ ! -f "$WAYBAR_DIR/config-$mode.jsonc" ]; then
        echo "Waybar mode not found: $mode"
        return 1
    fi

    ln -sfn "$WAYBAR_DIR/config-$mode.jsonc" \
        "$WAYBAR_DIR/config.jsonc"

    echo "$mode" > "$WAYBAR_MODE_STATE"

    build_waybar_css
}
