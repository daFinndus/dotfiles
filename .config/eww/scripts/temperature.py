#!/usr/bin/env python

import sys
import psutil

# Returns the current CPU usage percentage
def get_cpu_temperature(temperatures=None):
    if "coretemp" in temperatures:
        for entry in temperatures["coretemp"]:
            if entry.label == "Package id 0":
                return f"{entry.current}°C"
            
def get_nvme_temperature(temperatures=None):
    if "nvme" in temperatures:
        for entry in temperatures["nvme"]:
            if entry.label == "Composite":
                return f"{entry.current}°C"

# Renders an ASCII bar representing the CPU usage percentage
def render_ascii_bar(percentage=0):
    total_blocks = 10

    filled_blocks = int(min(percentage // 10, 10))
    empty_blocks = total_blocks - filled_blocks

    return "[" + "█" * filled_blocks + "░" * empty_blocks + "]"

if __name__ == "__main__":
    temperatures = psutil.sensors_temperatures()
    
    if sys.argv[1] == "cpu":
        print(get_cpu_temperature(temperatures))
    elif sys.argv[1] == "nvme":
        print(get_nvme_temperature(temperatures))