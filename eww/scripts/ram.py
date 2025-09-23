#!/usr/bin/env python

import sys
import psutil

# Returns the current RAM usage percentage
def get_percentage():
    return psutil.virtual_memory().percent

# Renders an ASCII bar representing the RAM usage percentage
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