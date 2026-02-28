#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Core paths
# -----------------------------------------------------------------------------

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME"

STATE_DIR="$HOME/.config/theme-system/state"
THEMES_DIR="$HOME/.config/themes"
WAYBAR_DIR="$HOME/.config/waybar"

DEFAULT_THEME="catppuccin/mocha"
DEFAULT_WAYBAR_MODE="informative"

# -----------------------------------------------------------------------------
# Flags
# -----------------------------------------------------------------------------

RESTOW=false
VERBOSE=false
ADOPT=false
DRY_RUN=false
INSTALL_DEPS=false

# -----------------------------------------------------------------------------
# Logging
# -----------------------------------------------------------------------------

log() { printf "%s\n" "$*"; }
info() { printf "• %s\n" "$*"; }
warn() { printf "⚠ %s\n" "$*"; }
die() { printf "Error: %s\n" "$*" >&2; exit 1; }

# -----------------------------------------------------------------------------
# Argument parsing
# -----------------------------------------------------------------------------

parse_args() {
  for arg in "${@:-}"; do
    case "$arg" in
      --restow|-R) RESTOW=true ;;
      --verbose|-v) VERBOSE=true ;;
      --adopt|-a) ADOPT=true ;;
      --dry-run|-n) DRY_RUN=true ;;
      --install-deps) INSTALL_DEPS=true ;;
      *) die "Unknown flag: $arg" ;;
    esac
  done
}

# -----------------------------------------------------------------------------
# Dependency handling
# -----------------------------------------------------------------------------

require() {
  command -v "$1" >/dev/null 2>&1
}

install_deps_arch() {
  if ! command -v pacman >/dev/null; then
    warn "pacman not found — skipping dependency installation"
    return
  fi

  info "Installing required packages"
  sudo pacman -S --needed stow
}

check_dependencies() {
  if require stow; then
    return
  fi

  if $INSTALL_DEPS; then
    install_deps_arch
    require stow || die "stow installation failed"
  else
    die "Missing dependency: stow (use --install-deps)"
  fi
}

# -----------------------------------------------------------------------------
# Repo validation
# -----------------------------------------------------------------------------

validate_repo() {
  [[ -d "$DOTFILES_DIR/apps" ]] || die "Missing apps directory"
  [[ -d "$DOTFILES_DIR/shells" ]] || die "Missing shells directory"
  [[ -d "$DOTFILES_DIR/themes" ]] || die "Missing themes directory"
}

# -----------------------------------------------------------------------------
# Stow configuration
# -----------------------------------------------------------------------------

build_stow_flags() {
  STOW_FLAGS=(-t "$TARGET")

  $ADOPT && STOW_FLAGS+=(--adopt)
  $RESTOW && STOW_FLAGS+=(-R)
  $VERBOSE && STOW_FLAGS+=(-v)
  $DRY_RUN && STOW_FLAGS+=(-n)
}

# -----------------------------------------------------------------------------
# Module discovery
# -----------------------------------------------------------------------------

is_stow_group() {
  case "$1" in
    apps|shells|scripts|themes) return 0 ;;
    *) return 1 ;;
  esac
}

discover_groups() {
  GROUPS=()

  for dir in "$DOTFILES_DIR"/*; do
    [[ -d "$dir" ]] || continue
    name="$(basename "$dir")"

    if is_stow_group "$name"; then
      GROUPS+=("$name")
    fi
  done

  IFS=$'\n' GROUPS=($(sort <<<"${GROUPS[*]}"))
  unset IFS

  [[ ${#GROUPS[@]} -gt 0 ]] || die "No stow groups found"
}

# -----------------------------------------------------------------------------
# Stow logic
# -----------------------------------------------------------------------------

stow_group() {
  local group="$1"
  local path="$DOTFILES_DIR/$group"

  info "Processing group: $group"

  shopt -s nullglob
  for pkg in "$path"/*/; do
    local pkg_name
    pkg_name="$(basename "$pkg")"

    info "Stowing $group/$pkg_name"
    stow "${STOW_FLAGS[@]}" --dir="$path" "$pkg_name"
  done
  shopt -u nullglob
}

stow_all() {
  for group in "${GROUPS[@]}"; do
    stow_group "$group"
  done
}

# -----------------------------------------------------------------------------
# Filesystem initialization
# -----------------------------------------------------------------------------

init_directories() {
  mkdir -p \
    "$HOME/.local/bin" \
    "$STATE_DIR"
}

# -----------------------------------------------------------------------------
# Theme system bootstrap
# -----------------------------------------------------------------------------

validate_theme() {
  local theme_path="$THEMES_DIR/$DEFAULT_THEME"
  [[ -d "$theme_path" ]] || die "Default theme not installed: $DEFAULT_THEME"
}

init_theme() {
  local current_link="$THEMES_DIR/current"

  if [[ -L "$current_link" ]]; then
    return
  fi

  info "Initializing theme → $DEFAULT_THEME"
  ln -sfn "$THEMES_DIR/$DEFAULT_THEME" "$current_link"
}

# -----------------------------------------------------------------------------
# Waybar system
# -----------------------------------------------------------------------------

init_waybar_mode() {
  local mode_file="$STATE_DIR/waybar-mode"
  local modes_dir="$WAYBAR_DIR/modes"

  [[ -d "$modes_dir" ]] || die "Waybar modes missing"

  if [[ ! -f "$mode_file" ]]; then
    if [[ -d "$modes_dir/$DEFAULT_WAYBAR_MODE" ]]; then
      echo "$DEFAULT_WAYBAR_MODE" > "$mode_file"
    else
      ls "$modes_dir" | head -n1 > "$mode_file"
    fi
  fi
}

compose_waybar_style() {
  local mode
  mode="$(cat "$STATE_DIR/waybar-mode")"

  local base="$WAYBAR_DIR/style-base.css"
  local mode_css="$WAYBAR_DIR/modes/$mode/style.css"
  local out="$WAYBAR_DIR/style.css"

  [[ -f "$base" ]] || die "Missing Waybar base style"
  [[ -f "$mode_css" ]] || die "Missing Waybar mode style"

  info "Composing Waybar style"
  cat "$base" "$mode_css" > "$out"

  info "Activating Waybar mode → $mode"
  ln -sfn \
    "$WAYBAR_DIR/modes/$mode/config.jsonc" \
    "$WAYBAR_DIR/config.jsonc"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
  parse_args "$@"

  info "Dotfiles directory: $DOTFILES_DIR"
  info "Target directory: $TARGET"

  validate_repo
  check_dependencies
  build_stow_flags
  discover_groups

  cd "$DOTFILES_DIR"

  stow_all
  init_directories
  validate_theme
  init_theme
  init_waybar_mode
  compose_waybar_style

  log
  log "Bootstrap complete."
  log "System ready."
}

main "$@"
