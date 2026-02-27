# Dotfiles

Personal Linux dotfiles built with a modular structure, theme system, and reproducible setup.

Designed primarily for:
* Arch Linux
* Niri
* GNU Stow
* Modular shell configuration

This repository acts more like a small configuration infrastructure rather than a simple dotfiles backup.

---

# Who is this for?

This repository is mainly for personal use, but others may find ideas or reuse parts of it.

The setup focuses on:
* Niri + Waybar
* systemd-managed user services
* modular themes
* GNU Stow deployment

---

# Overview

This setup focuses on:
* predictable configuration layout
* modular components
* theme switching
* minimal manual editing
* reproducible deployments

Most configuration is deployed through symlinks using stow.

---

# Repository Structure

dotfiles
├── apps        # Application configs (stow target)
├── scripts     # Helper scripts and theme tools
├── shells      # Bash / Zsh configuration
├── themes      # Theme packs
└── bootstrap.sh

Each directory is designed to be deployed independently.

---

# Quick Setup

Clone the repository:
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles

Run the bootstrap script:
bash bootstrap.sh

The script will:
* install application configs
* install shell configs
* install scripts
* install themes

---

# Manual Installation (Optional)

If you prefer manual control:

Install application configs:
cd apps
stow -t $HOME *

Install shells:
cd ../shells
stow -t $HOME *

Install scripts:
cd ../scripts
stow -t $HOME *

Install themes:
cd ../themes
stow -t $HOME *

---

# Session Model

Login manager: emptty
Compositor: Niri

The session itself is handled by systemd user services.

Example:
systemctl --user status niri.service

This repository does not manage the compositor startup directly.
It only manages configuration and supporting tools.

---

# Theme System

Themes are stored in:
themes/<theme-name>/.config/themes/<theme-name>/

Example:
themes/catppuccin/.config/themes/catppuccin/

Each theme may include configs for:
* Waybar
* GTK
* SwayNC
* Fuzzel
* Hyprlock
* Other supported applications

Themes are applied through symlink-based syncing, which means:
* switching themes is fast
* configs remain organized
* no config rewriting

---

# Current Themes

Available themes:
* catppuccin
* everforest
* gruvbox

Default theme:
catppuccin

---

# Theme Commands

Set a theme:
theme-set <theme>

Check current status:
theme-status

Reapply current theme:
theme-apply

---

# Waybar Modes

Waybar supports different layout modes.

Available modes:
* informative
* minimal

Default mode:
informative

Toggle mode:
waybar-toggle

Set a specific mode:
waybar-mode informative

---

# Managed Applications

This repository currently manages configuration for:

* Waybar
* Sway Notification Center (swaync)
* Fuzzel
* GTK (3 / 4)
* Shell environments
* Additional applications may be added over time.

---

# Requirements

Recommended packages:
stow
waybar
swaync
niri
eza
bat
git

---

# Bootstrap Script

The bootstrap script deploys all modules using stow.

Script:
bootstrap.sh

Responsibilities:
* verify dependencies
* deploy configurations
* prepare directories
* set up environment

---

# Philosophy

This setup follows a few guiding principles:
* reproducible configuration
* modular design
* minimal hidden logic
* predictable behavior
* easy recovery after reinstall

The goal is to keep the system understandable even months later.

---

# Future Improvements

Planned improvements may include:
* additional theme support
* better documentation for scripts
* optional module-based installs
* improved automation tools
