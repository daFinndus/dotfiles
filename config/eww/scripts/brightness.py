#!/usr/bin/env python

import sys
import subprocess as sub

# Function to get current brightness percentage
def get_brightness():
    first = sub.check_output(["brightnessctl", "get"], text=True)
    second = sub.check_output(["brightnessctl", "max"], text=True)

    current = int(first.strip())
    maximum = int(second.strip())

    percentage = round(current / maximum * 100)

    return percentage

# This function renders the bar based on brightness percentage
def render_ascii_bar(percentage=0):
    total = 10
    filled = int(min(percentage // 10, 10))
    empty = total - filled

    return "[" + "█" * filled + "░" * empty + "]"

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)
        
    if sys.argv[1] == "percentage":
        print(f"{get_brightness()} %")
    elif sys.argv[1] == "bar":
        print(render_ascii_bar(get_brightness()))
    elif sys.argv[1] == "json":
        import json
        brightness = get_brightness()
        bar = render_ascii_bar(brightness)
        print(json.dumps({"bar": bar, "percentage": f"{brightness} %"}))