#!/usr/bin/env bash

log() {
  echo "[STATUSBAR] $1"
}

handle() {
  # Get information about current workspaces and configured monitors
  WORKSPACES=$(hyprctl workspaces -j)
  MONITORS=$(hyprctl monitors -j)

  while read -r MONITOR; do
    # Get necessary monitor information
    NAME=$(echo "$MONITOR" | jq -r '.name')             # Like DP-3, HDMI-A-1, etc.
    ID=$(echo "$MONITOR" | jq -r '.activeWorkspace.id') # Checks which workspace is open on the monitor

    # Get workspace info for each monitor
    WORKSPACE=$(echo "$WORKSPACES" | jq -c ".[] | select(.id == $ID)") # Like 1, 5, depending on workspace
    WINDOWS=$(echo "$WORKSPACE" | jq -r '.windows')                    # Gives the amount of windows
    FULLSCREEN=$(echo "$WORKSPACE" | jq -r '.hasfullscreen')           # Boolean if the window is fullscreened

    WAYBAR=$(pgrep -f waybar)

    # If an application is fullscreened, hide eww and waybar
    if [ "$FULLSCREEN" = "true" ]; then
      log "Fullscreen on $NAME, hiding bars"

      [ -n "$WAYBAR" ] && pkill -f waybar
      continue
    fi

    if [ "$WINDOWS" -gt 0 ]; then
      # Show waybar
      log "At least one window detected, opening waybar on $NAME"
      [ -z "$WAYBAR" ] && waybar &
    elif [ "$WINDOWS" -eq 0 ]; then
      [ -n "$WAYBAR" ] && pkill -f waybar
    else
      # Close everything
      log "Don't know what to do... WINDOWS are '$WINDOWS'..."
    fi
  done < <(echo "$MONITORS" | jq -c "sort_by(.x) | .[]")
}

# Socket sanity check
: "${XDG_RUNTIME_DIR:?Error: XDG_RUNTIME_DIR not set}"
: "${HYPRLAND_INSTANCE_SIGNATURE:?Error: HYPRLAND_INSTANCE_SIGNATURE not set}"

# Listen for events from Hyprland's socket and call handle on each event
while true; do
  socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r _; do handle; done
  log "socat disconnected or failed, restarting in 1 second..."
  sleep 1
done
