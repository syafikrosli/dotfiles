#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME"

RESTOW=false
VERBOSE=false

for arg in "${@:-}"; do
  case "$arg" in
    --restow|-R) RESTOW=true ;;
    --verbose|-v) VERBOSE=true ;;
  esac
done

log() { printf "%s\n" "$*"; }
info() { printf "• %s\n" "$*"; }

require() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing dependency: $1"
    exit 1
  }
}

require stow

STOW_FLAGS=(-t "$TARGET" --adopt)
$RESTOW && STOW_FLAGS+=("-R")
$VERBOSE && STOW_FLAGS+=("-v")

cd "$DOTFILES_DIR"

info "Dotfiles directory: $DOTFILES_DIR"
info "Target directory: $TARGET"

stow_group() {
  local group="$1"
  [ -d "$group" ] || return

  for pkg in "$group"/*; do
    [ -d "$pkg" ] || continue
    info "Stowing $pkg"
    stow "${STOW_FLAGS[@]}" "$pkg"
  done
}

stow_group apps
stow_group shells
stow_group scripts
stow_group themes

# ---- required directories ----
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/theme-system/state"

# ---- theme initialization ----
THEMES_DIR="$HOME/.config/themes"
CURRENT_THEME_LINK="$THEMES_DIR/current"

if [ ! -L "$CURRENT_THEME_LINK" ]; then
  info "Initializing theme → catppuccin/mocha"
  ln -sfn \
    "$THEMES_DIR/catppuccin/mocha" \
    "$CURRENT_THEME_LINK"
fi

# ---- waybar initialization ----
WAYBAR_DIR="$HOME/.config/waybar"
MODE_DIR="$WAYBAR_DIR/modes"
STATE_MODE="$HOME/.config/theme-system/state/waybar-mode"

if [ ! -d "$MODE_DIR" ]; then
  echo "Waybar modes not installed correctly"
  exit 1
fi

if [ ! -f "$STATE_MODE" ]; then
  if [ -d "$MODE_DIR/informative" ]; then
    echo "informative" > "$STATE_MODE"
  else
    ls -1 "$MODE_DIR" | head -n1 > "$STATE_MODE"
  fi
fi

MODE="$(cat "$STATE_MODE")"

STYLE_BASE="$WAYBAR_DIR/style-base.css"
MODE_STYLE="$MODE_DIR/$MODE/style.css"
STYLE_OUT="$WAYBAR_DIR/style.css"

if [ -f "$STYLE_BASE" ] && [ -f "$MODE_STYLE" ]; then
  info "Composing Waybar style"
  cat "$STYLE_BASE" "$MODE_STYLE" > "$STYLE_OUT"
fi

info "Activating Waybar mode → $MODE"
ln -sfn "$MODE_DIR/$MODE/config.jsonc" "$WAYBAR_DIR/config.jsonc"

log
log "Bootstrap complete."
log
log "System ready."
