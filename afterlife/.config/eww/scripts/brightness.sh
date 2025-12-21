get() {
  ddcutil --bus 11 getvcp 10 --terse | awk '{print $4}'
}

increase() {
  BRIGHTNESS=$(get)
  NOW=$(echo $(("$BRIGHTNESS" + 10)))

  if [ "$NOW" -lt 100 ]; then
    ddcutil --bus 5 setvcp 10 "$NOW"
    ddcutil --bus 7 setvcp 10 "$NOW"
    ddcutil --bus 11 setvcp 10 "$NOW"
  fi
}

decrease() {
  BRIGHTNESS=$(get)
  NOW=$(echo $(("$BRIGHTNESS" - 10)))

  if [ "$NOW" -gt 0 ]; then
    ddcutil --bus 5 setvcp 10 "$NOW"
    ddcutil --bus 7 setvcp 10 "$NOW"
    ddcutil --bus 11 setvcp 10 "$NOW"
  fi
}

if [ "$1" = "increase" ]; then
  increase
elif [ "$1" = "decrease" ]; then
  decrease
fi
