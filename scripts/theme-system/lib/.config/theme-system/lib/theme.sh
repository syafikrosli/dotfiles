#!/usr/bin/env bash
source "$HOME/.config/theme-system/lib/core.sh"

validate_theme() {
    local theme="$1"

    local required=(
        "$THEME_DIR/$theme/fuzzel/fuzzel-$theme.ini"
        "$THEME_DIR/$theme/gtk-3.0/gtk-$theme.css"
        "$THEME_DIR/$theme/gtk-4.0/gtk-$theme.css"
        "$THEME_DIR/$theme/hypr/hyprlock-$theme.conf"
        "$THEME_DIR/$theme/swaync/style-$theme.css"
        "$THEME_DIR/$theme/waybar/style-base-$theme.css"
    )

    local missing=0

    for file in "${required[@]}"; do
        if [ ! -f "$file" ]; then
            echo "Missing theme file:"
            echo "$file"
            missing=1
        fi
    done

    if [ "$missing" -ne 0 ]; then
        echo
        echo "Theme validation failed."
        return 1
    fi

    return 0
}

set_theme() {
    local theme="$1"

    validate_theme "$theme" || return 1

    ln -sfn "$THEME_DIR/$theme/fuzzel/fuzzel-$theme.ini" \
        "$HOME/.config/fuzzel/fuzzel.ini"

    ln -sfn "$THEME_DIR/$theme/gtk-3.0/gtk-$theme.css" \
        "$HOME/.config/gtk-3.0/gtk.css"

    ln -sfn "$THEME_DIR/$theme/gtk-4.0/gtk-$theme.css" \
        "$HOME/.config/gtk-4.0/gtk.css"

    ln -sfn "$THEME_DIR/$theme/hypr/hyprlock-$theme.conf" \
        "$HOME/.config/hypr/hyprlock.conf"

    ln -sfn "$THEME_DIR/$theme/swaync/style-$theme.css" \
        "$HOME/.config/swaync/style.css"

    ln -sfn "$THEME_DIR/$theme/waybar/style-base-$theme.css" \
        "$WAYBAR_DIR/style-base.css"

    echo "$theme" > "$THEME_STATE"

    echo "Theme applied: $theme"
}
