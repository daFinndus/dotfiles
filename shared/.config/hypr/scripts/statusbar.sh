#!/usr/bin/env bash

handle() {
  # Check that eww daemon is running
  if ! pgrep -x eww >/dev/null; then
      eww daemon
      sleep 1
  fi

  # Get information about current workspaces and configured monitors
  WORKSPACES=$(hyprctl workspaces -j)
  MONITORS=$(hyprctl monitors -j)
  
  # Get the amount of monitors
  AMOUNT=$(echo "$MONITORS" | jq length)

  # Get the current workspace where eww is opened
  EWW=$(eww state | sed -n 's/^workspace: *\([0-9]\+\)$/\1/p' | tr -d '\r\n')

  # Save if eww shall be opened and to which monitor
  SHOW="no"
  TARGET=""

  echo "$MONITORS" | jq -c ".[]" | while read -r MONITOR; do
    NAME=$(echo "$MONITOR" | jq -r '.name')
    NUMBER=$(echo "$MONITOR" | jq -r '.id')
    ID=$(echo "$MONITOR" | jq -r '.activeWorkspace.id')

    # Get workspace info for each monitor
    WORKSPACE=$(echo "$WORKSPACES" | jq -c ".[] | select(.id == $ID)")
    WINDOWS=$(echo "$WORKSPACE" | jq -r '.windows')
    FULLSCREEN=$(echo "$WORKSPACE" | jq -r '.hasfullscreen')

    WAYBAR=$(pgrep -f "waybar --config .config/waybar/config-$NAME") 

    # If an application is fullscreened, hide eww and waybar
    if [ "$FULLSCREEN" = "true" ]; then
        echo "[STATUSBAR] Fullscreen is true, killing waybar"
        [ -n "$WAYBAR" ] && pkill -f "waybar --config .config/waybar/config-$NAME"
        continue
    fi

    if [ "$WINDOWS" -gt 0 ]; then
        # Show waybar
        echo "[STATUSBAR] At least one window detected, opening waybar on $NAME"
        [ -z "$WAYBAR" ] && waybar --config .config/waybar/config-"$NAME" &
    else
        # Show eww
        echo "[STATUSBAR] No windows detected on $NAME"
        if [ "$SHOW" = "no" ]; then
            SHOW="yes"
            TARGET="$NUMBER"
            echo "[STATUSBAR] Changing SHOW boolean to $SHOW and TARGET to $NUMBER for eww"
        fi
        # Kill waybar
        echo "[STATUSBAR] Killing waybar"
        [ -n "$WAYBAR" ] && pkill -f "waybar --config .config/waybar/config-$NAME"
    fi
  done

  if [ "$SHOW" = "yes" ]; then
      # Open eww widget on target monitor
      if [ -z "$EWW" ]; then
          echo "[STATUSBAR] SHOW boolean is $SHOW, opening statusbar widget on $TARGET"
          eww open statusbar --screen "$TARGET"
      # If eww is open on wrong target monitor
      elif [ "$EWW" != "$TARGET" ]; then
          echo "[STATUSBAR] The variable $EWW doesn't match $TARGET, closing statusbar and reopening on $TARGET"
          eww close statusbar
          sleep 0.5
          eww open statusbar --screen "$TARGET"
      fi
  else 
      # No empty monitor available
      echo "[STATUSBAR] SHOW variable is $SHOW, it seems all monitors have open windows, closing statusbar"
      [ -n "$EWW" ] && eww close statusbar
  fi
}

# socket sanity check
: "${XDG_RUNTIME_DIR:?Error: XDG_RUNTIME_DIR not set}"
: "${HYPRLAND_INSTANCE_SIGNATURE:?Error: HYPRLAND_INSTANCE_SIGNATURE not set}"

# Listen for events from Hyprland's socket and call handle on each event
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
while read -r _; do handle; done
  while read -r _; do handle; done
  echo "[STATUSBAR] socat disconnected or failed, restarting in 1 second..." >&2
  sleep 1
done
