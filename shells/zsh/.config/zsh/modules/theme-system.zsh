# Theme system helpers

if command -v theme-status >/dev/null 2>&1; then
  alias theme='theme-toggle'
  alias theme-mode='waybar-toggle'
fi
