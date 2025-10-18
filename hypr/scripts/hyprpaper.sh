#!/usr/bin/env bash

# Paths to wallpapers
WALL_DARK="/home/finn/Pictures/Wallpaper/lucy_artwork_dark.png"
WALL_LIGHT="/home/finn/Pictures/Wallpaper/lucy_artwork.png"

STATE=""

set_wallpaper() {
    fullscreen="$1"

    if [ "$fullscreen" = "true" ]; then
        echo "[FULLSCREEN] Switching to dark wallpaper"
        hyprctl hyprpaper wallpaper "eDP-1,$WALL_DARK"
    else
        echo "[WINDOWS] Switching to light wallpaper"
        hyprctl hyprpaper wallpaper "eDP-1,$WALL_LIGHT"
    fi
}

check_fullscreen() {
    local state=$(hyprctl activeworkspace -j)
    local fullscreen=$(echo "$state" | jq -r .hasfullscreen)

    if [ "$fullscreen" != "$STATE" ]; then
        set_wallpaper "$fullscreen"
        STATE="$fullscreen"
    fi

    sleep 
}

# Initial check
check_fullscreen

# socket sanity check
: "${XDG_RUNTIME_DIR:?Error: XDG_RUNTIME_DIR not set}"
: "${HYPRLAND_INSTANCE_SIGNATURE:?Error: HYPRLAND_INSTANCE_SIGNATURE not set}"

# Listen for Hyprland events and re-check whenever workspace changes
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
while read -r _; do check_fullscreen; done