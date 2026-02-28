#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$HOME/.config/theme-system"
STATE_DIR="$ROOT_DIR/state"

THEMES_DIR="$HOME/.config/themes"
CURRENT_LINK="$THEMES_DIR/current"

STATE_THEME="$STATE_DIR/theme"
STATE_WAYBAR_MODE="$STATE_DIR/waybar-mode"

WAYBAR_DIR="$HOME/.config/waybar"
WAYBAR_MODE_DIR="$WAYBAR_DIR/modes"
WAYBAR_STYLE_OUT="$WAYBAR_DIR/style.css"

DEFAULT_WAYBAR_MODE="informative"

ensure_state_dir() {
  mkdir -p "$STATE_DIR"
}

# -------------------------
# Notifications (SwayNC)
# -------------------------

notify() {
  command -v notify-send >/dev/null 2>&1 || return 0
  notify-send -a "theme-system" -u low -i preferences-desktop-theme "$1" "$2"
}

# -------------------------
# systemd helpers
# -------------------------

unit_exists() {
  systemctl --user list-unit-files --type=service --no-legend \
    | awk '{print $1}' | grep -Fxq "$1"
}

unit_active_or_enabled() {
  systemctl --user is-active "$1" >/dev/null 2>&1 \
  || systemctl --user is-enabled "$1" >/dev/null 2>&1
}

unit_supports_reload() {
  systemctl --user show "$1" -p CanReload --value 2>/dev/null | grep -qx yes
}

reload_service() {
  local svc="$1"

  unit_exists "$svc" || return 0
  unit_active_or_enabled "$svc" || return 0

  if unit_supports_reload "$svc"; then
    systemctl --user reload "$svc"
  else
    systemctl --user restart "$svc"
  fi
}

reload_ui() {
  reload_service waybar.service
  reload_service swaync.service
}

# -------------------------
# Waybar mode logic
# -------------------------

detect_mode() {
  if [[ -f "$STATE_WAYBAR_MODE" ]]; then
    cat "$STATE_WAYBAR_MODE"
    return
  fi

  if [[ -d "$WAYBAR_MODE_DIR/$DEFAULT_WAYBAR_MODE" ]]; then
    echo "$DEFAULT_WAYBAR_MODE"
    return
  fi

  ls -1 "$WAYBAR_MODE_DIR" | head -n1
}

save_mode() {
  echo "$1" > "$STATE_WAYBAR_MODE"
}

compose_waybar_style() {
  local mode="$1"

  local base="$WAYBAR_DIR/style-base.css"
  local mode_style="$WAYBAR_MODE_DIR/$mode/style.css"

  [[ -f "$base" ]] || return 0
  [[ -f "$mode_style" ]] || return 0

  cat "$base" "$mode_style" > "$WAYBAR_STYLE_OUT"
}

apply_waybar_mode() {
  local mode="$1"
  local mode_path="$WAYBAR_MODE_DIR/$mode"

  [[ -d "$mode_path" ]] || return 1

  compose_waybar_style "$mode"
  ln -sfn "$mode_path/config.jsonc" "$WAYBAR_DIR/config.jsonc"
  save_mode "$mode"
}

# -------------------------
# Theme helpers
# -------------------------

format_theme_name() {
  local theme="$1"
  local variant="$2"

  # Replace separators with spaces
  variant="${variant//-/ }"
  variant="${variant//_/ }"

  # Capitalize words
  theme="$(printf '%s\n' "$theme" | sed -E 's/(^|[-_ ])(.)/\U\2/g')"
  variant="$(printf '%s\n' "$variant" | sed -E 's/(^|[-_ ])(.)/\U\2/g')"

  echo "$theme $variant"
}

current_theme_name() {
  [[ -L "$CURRENT_LINK" ]] || return 0
  readlink "$CURRENT_LINK" | sed "s|$THEMES_DIR/||"
}

set_theme_link() {
  local theme="$1"
  local variant="$2"

  local target="$THEMES_DIR/$theme/$variant"
  [[ -d "$target" ]] || return 1

  ln -sfn "$target" "$CURRENT_LINK"
  echo "$theme/$variant" > "$STATE_THEME"
}
