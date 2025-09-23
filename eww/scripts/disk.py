#!/usr/bin/env python

import sys
import psutil

# Returns the current disk usage percentage
def get_percentage():
    disk = psutil.disk_usage("/")
    
    total = disk.total
    used = disk.used
    
    return round((used / total) * 100, 1)

# Renders an ASCII bar representing the disk usage percentage
def render_ascii_bar(percentage=0):
    total_blocks = 10

    filled_blocks = int(min(percentage // 10, 10))
    empty_blocks = total_blocks - filled_blocks

    return "[" + "█" * filled_blocks + "░" * empty_blocks + "]"

if __name__ == "__main__":
    if sys.argv[1] == "percentage":
        print(get_percentage())
    elif sys.argv[1] == "bar":
        print(render_ascii_bar(get_percentage()))