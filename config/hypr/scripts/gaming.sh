# Enable the monitors here
AMOUNT=$(hyprctl monitors -j | jq '.[].name' | wc -l)

if [ "$AMOUNT" -eq 1 ]; then
  hyprctl keyword monitor "HDMI-A-1, 1920x1080@120.0, 0x0, 1"
  hyprctl keyword monitor "DP-2, 1920x1080@100.0, 3840x0, 1"
else
  # Disable the monitors here
  hyprctl keyword monitor "HDMI-A-1, disable"
  hyprctl keyword monitor "DP-2, disable"
fi
