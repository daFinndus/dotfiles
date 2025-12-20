#!/usr/bin/env bash

CORES=$(nproc)
LOAD=$(awk '{print $1}' /proc/loadavg)

PERCENT=$(awk -v l="$LOAD" -v c="$CORES" 'BEGIN { printf "%.0f", (l/c)*100 }')

echo "$LOAD ($PERCENT%)"
