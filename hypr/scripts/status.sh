#!/bin/sh

handle() {
  case $1 in
    workspace*) echo "Workspace changed: $1" ;;
    activewindow*) echo "Window focus changed: $1" ;;
    monitoradded*) echo "Monitor connected: $1" ;;
    # Add more event handlers as needed
  esac

  WINDOWS=$(hyprctl activeworkspace -j | jq -r .windows)
  echo "Current amount of windows: $(echo $WINDOWS)"

  # If windows are open, start waybar if not already started
  # Else start eww daemon and run eww open statusbar
    if [ "$WINDOWS" -gt 0 ]; then
        pgrep waybar >/dev/null || waybar &
        pkill eww
    else
        pgrep eww >/dev/null || (eww daemon && eww open statusbar) &
        pkill waybar
    fi
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
