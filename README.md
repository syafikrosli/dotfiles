# Dotfiles

Personal Linux dotfiles designed as a **modular configuration system**, not just a backup.

This repository manages:

- Application configs
- Shell environments
- A theme system
- Waybar modes
- Small helper utilities

Primary environment:

- Arch Linux
- Niri (Wayland compositor)
- Waybar
- SwayNC
- GNU Stow

---

# Philosophy

This repository behaves like a small configuration framework.

Goals:

- Reproducible setup
- Modular structure
- Predictable behavior
- Easy theme switching
- Minimal manual editing
- Clean separation between configs, scripts, and themes

The idea is:

Install → Stow → Ready to use.

---

# Repository Structure

```
dotfiles
├── apps/        # Application configs (stow targets)
├── scripts/     # Theme system + helper scripts
├── shells/      # Shell environments
├── themes/      # Theme packs
└── bootstrap.sh # Initial setup helper
```

### apps

Contains application configurations.

Example:

```
apps/
  niri/
  waybar/
  swaync/
  alacritty/
```

These are deployed using **GNU Stow**.

---

### scripts

Contains the internal tooling for the system.

```
scripts/theme-system
├── bin/   # Executable commands
└── lib/   # Shared libraries
```

Commands provided:

- `theme-set`
- `theme-status`
- `theme-apply`
- `waybar-mode`
- `waybar-toggle`

---

### shells

Shell configurations are separated from apps.

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

### themes

Themes are structured to allow easy switching across apps.

```
themes/<theme-name>/.config/themes/<theme-name>/
```

Example:

```
themes/catppuccin
themes/everforest
themes/gruvbox
```

Each theme contains styles for supported applications.

---

# Installation

## Clone the repository

```
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

---

## Run bootstrap (recommended)

```
bash bootstrap.sh
```

This will:

- Install application configs
- Install shell configs
- Install scripts
- Install themes

---

## Manual installation (optional)

Install app configs:

```
cd apps
stow -t $HOME *
```

Install shell configs:

```
cd ../shells
stow -t $HOME *
```

Install scripts:

```
cd ../scripts
stow -t $HOME *
```

Install themes:

```
cd ../themes
stow -t $HOME *
```

---

# Theme System

Themes synchronize styling across supported applications.

Supported components:

- GTK
- Waybar
- SwayNC
- Fuzzel
- Hyprlock

Default theme:

```
catppuccin
```

---

## Theme commands

Set theme:

```
theme-set <theme>
```

Check current theme:

```
theme-status
```

Apply current theme again:

```
theme-apply
```

---

# Waybar Modes

Waybar supports multiple layouts.

Current modes:

- informative
- minimal

Default mode:

```
informative
```

---

## Waybar commands

Toggle between modes:

```
waybar-toggle
```

Set a specific mode:

```
waybar-mode <mode>
```

Example:

```
waybar-mode minimal
```

---

# Requirements

Recommended packages:

```
stow
niri
waybar
swaync
git
```

Optional tools:

```
eza
bat
```

---

# Bootstrapping Behavior

The bootstrap script installs:

- Apps
- Shells
- Scripts
- Themes

It expects:

```
~/.config
~/.local/bin
```

to exist (created automatically if missing).

---

# Design Notes

This setup is designed to behave closer to a **lightweight desktop configuration layer** rather than a basic dotfiles repo.

Features include:

- Theme-aware configuration
- Multiple UI layouts
- Scripted configuration management
- Systemd integration for services
- Stow-based deployment

Rebuild time on a fresh system is typically:

```
30 minutes – 2 hours
```

(depending mostly on internet speed and package installation).

---

# Safety

If bootstrap fails:

Manual stowing will still work because the repository layout follows standard XDG paths.

Example:

```
stow -t $HOME apps
```

---

# Future Improvements (optional ideas)

- Automatic theme switching (day / night)
- System validation script
- Optional package installer
- Waybar profile auto-detection
- Multi-machine setup support

---

# Final Note

This repository is mainly designed for personal use, but it is structured so that other users can explore or experiment with it if they want.
