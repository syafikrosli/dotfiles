#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME"

# ---- options ----
RESTOW=false
VERBOSE=false

for arg in "${@:-}"; do
  case "$arg" in
    --restow|-R) RESTOW=true ;;
    --verbose|-v) VERBOSE=true ;;
  esac
done

# ---- logging ----
log() { printf "%s\n" "$*"; }
info() { printf "• %s\n" "$*"; }

# ---- dependency check ----
require() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing dependency: $1"
    exit 1
  fi
}

require stow

STOW_FLAGS=()
$RESTOW && STOW_FLAGS+=("-R")
$VERBOSE && STOW_FLAGS+=("-v")

cd "$DOTFILES_DIR"

info "Dotfiles directory: $DOTFILES_DIR"
info "Target directory: $TARGET"

# ---- stow packages ----
stow_group() {
  local group="$1"

  [ -d "$group" ] || return

  for pkg in "$group"/*; do
    [ -d "$pkg" ] || continue

    local name
    name="$(basename "$pkg")"

    info "Stowing $group/$name"
    stow "${STOW_FLAGS[@]}" -t "$TARGET" "$pkg"
  done
}

stow_group apps
stow_group shells
stow_group scripts
stow_group themes

# ---- theme system bootstrap ----
info "Preparing theme system"

mkdir -p "$HOME/.config/theme-system/state"

if [ ! -L "$HOME/.config/themes/current" ]; then
  info "Setting default theme → catppuccin/mocha"
  ln -s \
    "$HOME/.config/themes/catppuccin/mocha" \
    "$HOME/.config/themes/current"
fi

# ---- ensure required dirs exist ----
mkdir -p "$HOME/.local/bin"

# ---- summary ----
log
log "Bootstrap complete."
log
log "Optional:"
log "  ./bootstrap.sh --restow   # rebuild symlinks"
log "  ./bootstrap.sh --verbose  # debug stow output"
