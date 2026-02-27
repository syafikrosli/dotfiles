#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"
THEME_DIR="$CONFIG_DIR/themes"
WAYBAR_DIR="$CONFIG_DIR/waybar"
STATE_DIR="$CONFIG_DIR/theme-system/state"

THEME_STATE="$STATE_DIR/theme"
WAYBAR_MODE_STATE="$STATE_DIR/waybar-mode"

reload_services() {
    systemctl --user reload-or-restart waybar.service
    systemctl --user reload-or-restart swaync.service
}
