#!/usr/bin/env python

import json
import subprocess as sub

from time import sleep

# This function is for decoding shell output
def decode(string):
    return string.decode("utf-8").strip()

# This will return the volume percentage as int
def get_volume_percentage():
    output = sub.check_output("pamixer --get-volume", shell=True)
    decoded = decode(output)
    percentage = int(decoded)
    
    return percentage
    
# This will return a boolean if the sound is muted
def get_mute_status():
    output = sub.check_output("pamixer --get-mute", shell=True)
    decoded = decode(output)
    boolean = decoded == "true"
    
    return boolean

def calculate_icon(percentage=0, muted=False):
    if muted:
        return " "
    elif percentage == 0:
        return " "
    elif percentage <= 40:
        return ""
    else:
        return ""

def render_ascii_bar(percentage=0, muted=False):      
    total_blocks = 10
    
    if muted: return "[" + "░" * total_blocks + "]"
    
    filled_blocks = int(min(percentage // 10, 10))
    empty_blocks = total_blocks - filled_blocks
    
    return "[" + "█" * filled_blocks + "░" * empty_blocks + "]"

def get_audiosystem():
    output = sub.check_output("pactl info | grep 'Server Name'", shell=True)
    decoded = decode(output)
    
    return decoded

def get_class(percentage=0, muted=False):
    if percentage == 0 or muted:
        return "critical"
    elif percentage <= 15:
        return "warning"
    elif percentage > 15 and percentage <= 30:
        return "bad"
    else:
        return "good"

def main():
    while True:
        percentage = get_volume_percentage()
        muted = get_mute_status()

        bar = render_ascii_bar(percentage, muted)
        icon = calculate_icon(percentage, muted)

        text = f"{icon}  {bar}  {percentage}%"
        tooltip = get_audiosystem()

        css = get_class(percentage, muted)

        print(json.dumps({
            "text": text,
            "tooltip": tooltip,
            "class": css,
        }), flush=True)

        sleep(0.1)

if __name__ == "__main__":
    main()
    
    