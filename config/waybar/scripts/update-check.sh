#!/bin/sh

# Check for internet connectivity
wget -q --spider https://www.google.com
if [ $? -ne 0 ]; then
  echo '{"text":"ERROR!", "tooltip":"No internet connection", "class":"error"}'
  exit 0
fi

# Fetch the raw list of updates
list=$(checkupdates)
count=$(echo "$list" | wc -l)

# If checkupdates returns an empty list, count will be 1 with a blank line;
# we check if the string itself is empty.
if [ -z "$list" ]; then
  echo '{"text":"Fully Updated", "tooltip":"Your system is up to date", "class":"updated"}'
else
  # Format the tooltip: replace actual newlines with literal '\n' for JSON
  # We limit to the first 25 packages to prevent the tooltip from being too large
  tooltip=$(echo "$list" | head -n 25 | awk '{printf "%s%s", sep, $0; sep="\\n"}')
  [ "$count" -gt 25 ] && tooltip="${tooltip}and more..."

  # Output JSON object Waybar expects
  echo "{\"text\":\"$count Updates\", \"tooltip\":\"$tooltip\", \"class\":\"pending\"}"
fi
