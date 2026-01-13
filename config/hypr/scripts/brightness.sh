#!/usr/bin/env bash

# This script is used to toggle the brightness of my monitors ;^)

BRIGHTNESS=$(ddcutil --bus 11 getvcp 10 --terse | awk '{print $4}') # This only fetches the monitor brightness for DP-3
WALLPAPER=$(cat /home/finn/.config/hypr/scripts/wallpaper)

log() {
  echo "[BRIGHTNESS] $1"
}

log "It seems BRIGHTNESS is $BRIGHTNESS"

if [ "$BRIGHTNESS" -eq 100 ]; then
  ddcutil --bus 5 setvcp 10 0
  log "Reduced brightness for HDMI-A-1"

  sleep 0.5

  ddcutil --bus 7 setvcp 10 0
  log "Reduced brightness for DP-2"

  sleep 0.5

  ddcutil --bus 11 setvcp 10 0
  log "Reduced brightness for DP-3"

  /home/finn/.config/hypr/scripts/wallpaper.sh /home/finn/Pictures/Wallpaper/windows.jpg
  log "Set dark wallpaper"

  echo "$WALLPAPER" >/home/finn/.config/hypr/scripts/wallpaper
else
  ddcutil --bus 5 setvcp 10 100
  log "Increased brightness for HDMI-A-1"

  sleep 0.5

  ddcutil --bus 7 setvcp 10 100
  log "Increased brightness for DP-2"

  sleep 0.5

  ddcutil --bus 11 setvcp 10 100
  log "Increased brightness for DP-3"

  /home/finn/.config/hypr/scripts/wallpaper.sh
  log "Set bright wallpaper"
fi

log "Everything done! :)"
