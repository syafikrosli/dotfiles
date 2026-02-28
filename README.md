# Dotfiles

Personal Linux dotfiles designed as a **modular configuration system**, not just a backup.

This repository manages:

* Application configs
* Shell environments
* A theme system
* Waybar modes
* Helper utilities

Primary environment:

* Arch Linux
* Niri (Wayland compositor)
* Waybar
* SwayNC
* GNU Stow

---

# Philosophy

This repository behaves like a small configuration framework.

Goals:

* Reproducible setup
* Modular structure
* Predictable behavior
* Easy theme switching
* Minimal manual editing
* Clean separation between configs, scripts, and themes

Basic workflow:

Install → Stow → Ready to use

---

# Repository Structure

```
dotfiles
├── apps/        # Application configs (stow targets)
├── scripts/     # Theme system + utilities
├── shells/      # Shell environments
├── themes/      # Theme packs
└── bootstrap.sh # Initial setup helper
```

---

## apps

Application configurations deployed using **GNU Stow**.

Current apps included:

```
alacritty
hypr (hypridle)
micro
niri
swaync
waybar
xdg-desktop-portal (niri portals)
```

Waybar layouts are stored as modes:

```
apps/waybar/.config/waybar/modes/
```

Available modes:

```
informative
minimal
```

---

## scripts

Internal tooling used by the system.

```
scripts/theme-system
├── bin
└── lib
```

Installed commands:

```
theme
waybar-mode
waybar-toggle
```

---

## shells

Shell environments are separated from application configs.

```
shells/
  bash/
  zsh/
```

Zsh modules are loaded from:

```
~/.config/zsh/modules
```

---

## themes

Themes are structured for cross-application styling.

```
themes/<theme>/.config/themes/<theme>/<variant>/
```

Example:

```
themes/catppuccin
themes/everforest
themes/gruvbox
```

Current default:

```
catppuccin mocha
```

---

# Installation

## Clone repository

```
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

---

## Run bootstrap

Recommended method:

```
bash bootstrap.sh
```

Bootstrap will deploy all configs using GNU Stow.

* Install application configs
* Install shell configs
* Install scripts
* Install themes

Bootstrap only performs **stow deployment**.

---

## Manual installation

Apps:

```
cd apps
stow -t $HOME *
```

Shells:

```
cd ../shells
stow -t $HOME *
```

Scripts:

```
cd ../scripts
stow -t $HOME *
```

Themes:

```
cd ../themes
stow -t $HOME *
```

---

# Theme System

Themes synchronize styling across supported applications.

Supported components:

* GTK
* Waybar
* SwayNC
* Fuzzel
* Hyprlock

Themes currently available:

```
catppuccin (mocha)
everforest (dark-hard)
gruvbox (dark)
```

---

# Theme Command Reference

List available themes:

```
theme list
```

Set a theme:

```
theme set <theme> <variant>
```

Apply a theme and optionally set Waybar mode:

```
theme apply <theme> <variant> [mode]
```

Check current theme:

```
theme current
```

Example:

```
theme set catppuccin mocha
theme apply catppuccin mocha minimal
```

---

# Waybar Modes

Switch modes manually:

```
waybar-mode <mode>
```

Toggle between modes:

```
waybar-toggle
```

Available modes:

```
informative
minimal
```

Default mode:

```
informative
```

---

# Requirements

Recommended packages:

```
stow
git
niri
waybar
swaync
```

Optional tools:

```
eza
bat
```

---

# Bootstrapping Behavior

Bootstrap installs configurations into:

```
~/.config
~/.local/bin
```

If these directories do not exist, they are created automatically.

Because the repository follows standard XDG paths, manual stowing will always work.

Example:

```
stow -t $HOME apps
```

---

# Design Notes

This setup is designed to behave closer to a **lightweight desktop configuration layer** rather than a basic dotfiles repository.

Features include:

* Theme-aware configuration
* Multiple UI layouts
* Scripted configuration management
* Stow-based deployment
* Modular structure

## Testing

This configuration is regularly tested on:

- Clean Arch Linux installs
- EndeavourOS live ISO environments

---

# Notes

This repository is mainly designed for personal use, but it is structured so that others can explore or experiment with it.
