#!/usr/bin/env python

import sys
import time
import psutil

# Returns the current disk usage percentage
def get_uptime():
    current = time.time()
    boot = psutil.boot_time()
    
    return f"{int(current - boot) // 60} mins"

# Renders an ASCII bar representing the disk usage percentage
def get_remaining():
    battery = psutil.sensors_battery()

    if battery.secsleft == psutil.POWER_TIME_UNLIMITED:
        return "Charging..."
    elif battery.secsleft == psutil.POWER_TIME_UNKNOWN:
        return "Error!"
    else:
        remaining = battery.secsleft // 60
        return f"{remaining} mins"
        
    

if __name__ == "__main__":
    if sys.argv[1] == "uptime":
        print(get_uptime())
    elif sys.argv[1] == "remaining":
        print(get_remaining())