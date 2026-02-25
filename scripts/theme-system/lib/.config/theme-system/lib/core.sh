#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/theme-system"
STATE_DIR="${CONFIG_DIR}/state"
WAYBAR_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"

mkdir -p "$STATE_DIR"

THEME_FILE="$STATE_DIR/theme"
WAYBAR_MODE_FILE="$STATE_DIR/waybar-mode"

DEFAULT_THEME="catppuccin"
DEFAULT_WAYBAR_MODE="informative"

notify() {
    notify-send "theme-system" "$1"
}

read_state() {
    local file="$1"
    local default="$2"

    [[ -f "$file" ]] && cat "$file" || echo "$default"
}

write_state() {
    printf '%s\n' "$2" > "$1"
}
