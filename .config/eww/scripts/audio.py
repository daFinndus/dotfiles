#!/usr/bin/env python

import sys
import subprocess as sub

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

def render_ascii_bar(percentage=0, muted=False):
    total_blocks = 10

    if muted: return "[" + "░" * total_blocks + "]"

    filled_blocks = int(min(percentage // 10, 10))
    empty_blocks = total_blocks - filled_blocks

    return "[" + "█" * filled_blocks + "░" * empty_blocks + "]"

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)
        
    percentage = get_volume_percentage()
    mute = get_mute_status()
    
    if sys.argv[1] == "percentage":
        if mute: print("MUTE")
        else: print(f"{percentage} %")
    elif sys.argv[1] == "bar":
        print(render_ascii_bar(percentage, mute))
    elif sys.argv[1] == "json":
        import json
        bar = render_ascii_bar(percentage, mute)
        perc = "MUTE" if mute else f"{percentage} %"
        print(json.dumps({"bar": bar, "percentage": perc}))

