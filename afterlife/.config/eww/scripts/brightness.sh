get() {
  ddcutil --bus 11 getvcp 10 --terse | awk '{print $4}'
}

log() {
  echo "[DDCUTIL] $1"
}

increase() {
  BRIGHTNESS=$(get)
  NOW=$(echo $(("$BRIGHTNESS" + 10)))

  if [ "$NOW" -lt 100 ] || [ "$NOW" -eq 100 ]; then
    ddcutil --bus 5 setvcp 10 "$NOW"
    ddcutil --bus 7 setvcp 10 "$NOW"
    ddcutil --bus 11 setvcp 10 "$NOW"
  else
    log "Cannot increase, brightness would be '$NOW'"
  fi
}

decrease() {
  BRIGHTNESS=$(get)
  NOW=$(echo $(("$BRIGHTNESS" - 10)))

  if [ "$NOW" -gt 0 ] || [ "$NOW" -eq 0 ]; then
    ddcutil --bus 5 setvcp 10 "$NOW"
    ddcutil --bus 7 setvcp 10 "$NOW"
    ddcutil --bus 11 setvcp 10 "$NOW"
  else
    log "Cannot decrease, brightness would be '$NOW'"
  fi
}

render_ascii_bar() {
  local blocks=10
  local percentage=${1:-0}

  local filled=$((percentage / 10))

  ((filled > blocks)) && filled=$blocks
  local empty=$((blocks - filled))

  printf "[%*s%*s]\n" "$filled" "" "$empty" "" | tr ' ' '█░'
}

if [ "$1" = "increase" ]; then
  increase
elif [ "$1" = "decrease" ]; then
  decrease
elif [ "$1" = "percentage" ]; then
  render_ascii_bar $(get)
fi
