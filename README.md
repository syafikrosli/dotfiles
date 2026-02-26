# Dotfiles

Personal Linux dotfiles with a modular structure, theme system, and Waybar modes.

Designed for:

* Arch Linux
* Niri (Wayland compositor)
* GNU Stow
* Modular shell configs (Zsh / Bash)

---

# Structure

```
dotfiles
├── apps        # Application configs (stow target)
├── scripts     # Theme system + helper scripts
├── shells      # Bash / Zsh configs
├── themes      # Theme packs
└── bootstrap.sh
```

---

# Installation

Clone the repository:

```
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Stow application configs:

```
cd apps
stow -t $HOME *
```

Stow shells (optional):

```
cd ../shells
stow -t $HOME *
```

Run bootstrap (recommended on first setup):

```
bash bootstrap.sh
```

---

# Theme System

Themes are stored in:

```
themes/<theme-name>/.config/themes/<theme-name>/
```

Current themes included:

* catppuccin
* everforest
* gruvbox

Default theme:

```
catppuccin
```

---

# Waybar Modes

Waybar supports multiple modes.

Current modes:

* informative
* minimal

Default mode:

```
informative
```

Toggle mode:

```
waybar-toggle
```

Set specific mode:

```
waybar-mode informative
```

---

# Theme Commands

Set theme:

```
theme-set <theme>
```

Toggle theme:

```
theme-toggle
```

Check status:

```
theme-status
```

Sync current theme:

```
theme-sync
```

---

# Requirements

Recommended packages:

```
stow
waybar
swaync
niri
eza
bat
```

---

# Notes

* Waybar config and style are automatically selected based on mode.
* Theme system handles syncing across supported apps.
* Modular Zsh system loads extensions from:

```
~/.config/zsh/modules
```

---

# Philosophy

This repo is designed more like a small configuration infrastructure than a simple backup.

Goals:

* reproducible setup
* modular configs
* easy theme switching
* predictable behavior
* minimal manual editing
