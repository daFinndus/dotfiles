#!/usr/bin/env bash

# Spinner frames
FRAMES=('/' '—' "\\" '|')

HWMON=$(find /sys/class/hwmon/*/ -name "fan1_input" | head -n1)

# Get fan RPM
get_rpm() {
  echo $(cat "$HWMON")
}

# Print current RPM only
if [ "$1" == "rpm" ]; then
  echo "$(get_rpm) RPM"
  exit 0
fi

# Render spinning fan
render_fan() {
  local i=0

  while true; do
    local rpm=$(get_rpm)
    local delay=$((500 - (rpm * 450 / 6800)))
    if [ $delay -lt 50 ]; then
      delay=50
    fi

    if [ $rpm -eq "0" ]; then
      printf "[ %s ]\n" "—"
    else
      printf "[ %s ]\n" "${FRAMES[$i]}"
      i=$(((i + 1) % 4))
    fi

    # Force flush output for eww
    fflush stdout 2>/dev/null || true

    sleep "$(echo "scale=3; $delay/1000" | bc)"
  done
}

# JSON output with animated spinner
if [ "$2" == "json" ]; then
  rpm=$(get_rpm)
  # Rotate through frames based on current time
  frame_idx=$((($(date +%s) / 1) % 4))
  if [ $rpm -eq "0" ]; then
    spinner="[ — ]"
  else
    spinner="[ ${FRAMES[$frame_idx]} ]"
  fi
  echo "{\"rpm\": \"$rpm RPM\", \"spinner\": \"$spinner\"}"
  exit 0
fi

# Run spinner if "fan" is requested
if [ "$1" == "fan" ]; then
  render_fan
fi
