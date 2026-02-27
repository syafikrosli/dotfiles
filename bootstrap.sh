#!/usr/bin/env bash
set -Eeuo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

require() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing dependency: $1"
    exit 1
  }
}

require stow
require git

echo "Dotfiles directory: $DOTFILES_DIR"

mkdir -p \
  "$HOME/.config" \
  "$HOME/.local/bin"

echo
echo "Installing apps..."
cd "$DOTFILES_DIR/apps"
stow -R -t "$HOME" */

echo
echo "Installing shell configs..."
cd "$DOTFILES_DIR/shells"
stow -R -t "$HOME" */

echo
echo "Installing scripts..."
cd "$DOTFILES_DIR/scripts"
stow -R -t "$HOME" */

echo
echo "Installing themes..."
cd "$DOTFILES_DIR/themes"
stow -R -t "$HOME" */

echo
echo "Bootstrap complete."
echo "You can safely run this script multiple times."
echo "Existing symlinks will be updated."
