#!/bin/bash

# Get bluetooth status
status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

# Toggle on if off and off if on
if [ "$status" == "yes" ]; then
    bluetoothctl power off
    echo "Bluetooth turned off"
else
    bluetoothctl power on
    echo "Bluetooth turned on"
fi
