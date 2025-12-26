#!/usr/bin/env bash

WALLPAPER_FILE="$HOME/.config/hypr/scripts/wallpaper"

# Wait for hyprpaper socket
wait_for_hyprpaper() {
  SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.hyprpaper.sock"

  echo "[WALLPAPER] Waiting for hyprpaper socket: $SOCKET"

  for i in {1..50}; do
    if [ -S "$SOCKET" ]; then
      echo "[WALLPAPER] hyprpaper socket is ready."
      return 0
    fi
    sleep 0.1
  done

  echo "[WALLPAPER] ERROR: hyprpaper socket did not appear!" >&2
  return 1
}

change() {
  echo "[WALLPAPER] Executing script at $(date)"

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

  if ! pgrep hyprpaper >/dev/null; then
    hyprpaper
    sleep 3
  fi

  # Check if hyprpaper is fully executed yet
  wait_for_hyprpaper || return 1

  hyprctl hyprpaper preload "$WALLPAPER_PATH"
  hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH"

  echo "$WALLPAPER_PATH" >"$WALLPAPER_FILE"
  echo "[WALLPAPER] Saved to $WALLPAPER_FILE"

  echo "[PYWAL] Applying pywal colorscheme..."

  wal -i "$WALLPAPER_PATH"

  echo "[WAYBAR] Killing waybar, restart will be executed by statusbar.sh..."
  systemctl --user restart statusbar.service

  makoctl reload

  notify-send "Selfmade wallpaper script" "Updated wallpaper and themes!"
}

change "$1"
