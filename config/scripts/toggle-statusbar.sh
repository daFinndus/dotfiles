# Check if waybar is running
WAYBAR=$(pgrep waybar)

if [ -z $WAYBAR ]; then
  waybar &
  disown
else
  pkill waybar
fi
