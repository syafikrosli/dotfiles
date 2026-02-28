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

# Quick Start

git clone <repo>
cd dotfiles
./bootstrap.sh

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

Clone → Bootstrap → Ready to use

---

# Repository Structure

Each top-level directory is deployed independently via GNU Stow, allowing selective installation and modular configuration management.

```
dotfiles
├── apps/        # Application configs (stow targets)
├── scripts/     # Theme system + utilities
├── shells/      # Shell environments
├── themes/      # Theme packs
└── bootstrap.sh # Environment bootstrap
```

---

## apps

Application configurations deployed using **GNU Stow**.

Current applications included:

```
hypr (hypridle)
niri
swaync
waybar
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

Example themes:

```
catppuccin
everforest
gruvbox
```

Default theme:

```
catppuccin mocha
```

---

# Installation

Clone the repository:

```
git clone <repo>
cd dotfiles
```

Run bootstrap:

```
./bootstrap.sh
```

Bootstrap performs:

* Deploys all modules using `stow`
* Creates required directories
* Initializes the theme system
* Sets the default theme
* Sets a default Waybar mode
* Generates Waybar `style.css`
* Links the active Waybar configuration

After this step the environment is ready to use.

---

# Bootstrap Options

Bootstrap is designed to be safe to run multiple times.
Bootstrap supports several flags:

Dry run (preview changes)

```
./bootstrap.sh --dry-run
```

Verbose mode

```
./bootstrap.sh --verbose
```

Adopt existing files into stow

```
./bootstrap.sh --adopt
```

Restow everything

```
./bootstrap.sh --restow
```

Automatically install required dependencies (Arch Linux)

```
./bootstrap.sh --install-deps
```

Example:

```
./bootstrap.sh --restow --verbose
```

---

# Manual Installation

If you prefer manual control:

Apps

```
cd apps
stow -t $HOME */
```

Shells

```
cd ../shells
stow -t $HOME */
```

Scripts

```
cd ../scripts
stow -t $HOME */
```

Themes

```
cd ../themes
stow -t $HOME */
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

Available themes:


* catppuccin (mocha)
* everforest (dark-hard)
* gruvbox (dark)


---

# Theme Commands

List available themes:

```
theme list
```

Set a theme:

```
theme set <theme> <variant>
```

Apply a theme and optionally change Waybar mode:

```
theme apply <theme> <variant> [mode]
```

Show current theme:

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

Switch modes:

```
waybar-mode <mode>
```

Toggle between modes:

```
waybar-toggle
```

Available modes:

* informative
* minimal


Default mode:

* informative

---

# Requirements

Core dependencies:

* stow
* git

Desktop components used:

* niri
* waybar
* swaync

Optional utilities:

* eza
* bat

---

# Bootstrapping Behavior

Bootstrap installs files into:

```
~/.config
~/.local/bin
```

Required directories are created automatically.

Because the repository follows standard XDG paths, manual stowing will always work.

Example:

```
stow -t $HOME apps
```

---

# Design Notes

This setup behaves closer to a **lightweight desktop configuration layer** than a basic dotfiles repository.

Features:

* Theme-aware configuration
* Multiple UI layouts
* Scripted configuration management
* Stow-based deployment
* Modular structure

---

# Testing

This configuration is regularly tested on:

* Clean Arch Linux installs
* EndeavourOS live environments

---

# Notes

This repository is primarily for personal use but is structured so others can explore or adapt it.
