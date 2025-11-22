#!/usr/bin/env python

import sys
import psutil

# Returns the current CPU usage percentage
def get_percentage():
    return psutil.cpu_percent(interval=0.1)

# Renders an ASCII bar representing the CPU usage percentage
def render_ascii_bar(percentage=0):
    total_blocks = 10

    filled_blocks = int(min(percentage // 10, 10))
    empty_blocks = total_blocks - filled_blocks

    return "[" + "█" * filled_blocks + "░" * empty_blocks + "]"

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)
        
    if sys.argv[1] == "percentage":
        print(f"{get_percentage()} %")
    elif sys.argv[1] == "bar":
        print(render_ascii_bar(get_percentage()))
    elif sys.argv[1] == "json":
        import json
        percentage = get_percentage()
        bar = render_ascii_bar(percentage)
        print(json.dumps({"bar": bar, "percentage": f"{percentage} %"}))