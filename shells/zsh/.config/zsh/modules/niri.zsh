# Detect if running under Niri
if [[ "$XDG_CURRENT_DESKTOP" == "niri" ]] || pgrep -x niri >/dev/null 2>&1; then
  export WAYLAND_COMPOSITOR=niri
fi

# Wayland compatibility
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland

# Theme system binaries
path_prepend "$HOME/.config/theme-system/bin"
