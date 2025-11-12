#!/usr/bin/env bash

WALLPAPER_FILE="$HOME/.config/hypr/wallpaper"

change() {
    WALLPAPER_PATH="$1"

    if [ -z "$WALLPAPER_PATH" ]; then
        if [ -f "$WALLPAPER_FILE" ]; then
            WALLPAPER_PATH=$(cat "$WALLPAPER_FILE")
            echo "[WALLPAPER] Loading wallpaper from $WALLPAPER_FILE"
        else
            echo "[WALLPAPER] No wallpaper specified and no saved found" >&2
            return 1
        fi
    fi

    if [ ! -f "$WALLPAPER_PATH" ]; then
	    echo "[WALLPAPER] File does not exist: $WALLPAPER_PATH" >&2
	    return 1
    fi

    echo "[WALLPAPER] Applying wallpaper: $WALLPAPER_PATH"

    echo "[WALLPAPER] Updating hyprpaper..."

    hyprctl hyprpaper preload "$WALLPAPER_PATH"
    hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH"
    hyprctl hyprpaper wallpaper "eDP-1,$WALLPAPER_PATH"

    echo "$WALLPAPER_PATH" > "$WALLPAPER_FILE"
    echo "[WALLPAPER] Saved to $WALLPAPER_FILE"

    echo "[PYWAL] Applying pywal colorscheme..."

    wal -i "$WALLPAPER_PATH"
    
    echo "[WAYBAR] Killing waybar, restart will be executed by statusbar.sh..."
    pkill waybar
    pkill eww
}

change "$1"
