#!/usr/bin/env bash

handle() {
  STATE=$(hyprctl activeworkspace -j)
  WINDOWS=$(echo "$STATE" | jq -r .windows)
  FULLSCREEN=$(echo "$STATE" | jq -r .hasfullscreen)

  WAYBAR=$(pgrep -x waybar)
  EWW=$(eww active-windows | grep -q statusbar && echo 1 || echo 0)

  if [ "$FULLSCREEN" = "true" ]; then
    echo "[STATE] Fullscreen"
    [ "$EWW" -eq 1 ] && eww close statusbar
    [ -n "$WAYBAR" ] && pkill waybar

  elif [ "$WINDOWS" -gt 0 ]; then
    echo "[STATE] Windows: $WINDOWS"
    [ "$EWW" -eq 1 ] && eww close statusbar
    [ -z "$WAYBAR" ] && waybar &

  elif [ "$WINDOWS" -eq 0 ]; then
    echo "[STATE] Desktop"
    [ "$EWW" -eq 0 ] && eww open statusbar
    [ -n "$WAYBAR" ] && pkill waybar
  fi
}

# socket sanity check
: "${XDG_RUNTIME_DIR:?Error: XDG_RUNTIME_DIR not set}"
: "${HYPRLAND_INSTANCE_SIGNATURE:?Error: HYPRLAND_INSTANCE_SIGNATURE not set}"

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
while read -r _; do handle; done
