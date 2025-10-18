#!/usr/bin/env python

import json
import time
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

def calculate_icon(percentage=0):
    if percentage == 0:
        return ""
    elif percentage <= 30:
        return ""
    elif percentage <= 70:
        return ""
    else:
        return ""

def get_class(percentage=0):
    if percentage == 0:
        return "critical"
    elif percentage <= 15:
        return "warning"
    elif percentage > 15 and percentage <= 30:
        return "bad"
    else:
        return "good"

def main():
    while True:
        percentage = get_brightness()
        icon = calculate_icon(percentage)
        bar = render_ascii_bar(percentage)

        text = f"{icon}  {bar}  {percentage}%"

        css = get_class(percentage)

        print(json.dumps({
            "text": text,
            "tooltip": f"Brightness: {percentage}%",
            "class": css,
        }), flush=True)

        time.sleep(0.1)

if __name__ == "__main__":
    main()
