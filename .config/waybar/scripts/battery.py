#!/usr/bin/env python

import json
import psutil
import datetime

# This will return the battery icon based on the percentage
def calculate_icon(percentage=0, charging=False):
    if charging: return "󰂄"
    
    icons = ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    
    # Calculate the index for the icon list
    index = int(min(percentage // 10, 9))
    
    return icons[index]

# This function renders the bar based on battery percentage
def render_ascii_bar(percentage=0, charging=False):
    if charging:
        index = datetime.datetime.now().second % 10
    else:
        index = int(min(percentage // 10, 9))

    total = 10
    filled = index + 1
    empty = total - filled
    
    return "[" + "█" * filled + "░" * empty + "]"

# This function calculates the time left for battery
def calculate_time_left(time=60, charging=False):
    if charging: 
        return("Charging...")
    else:
        m, s = divmod(time, 60)
        h, m = divmod(m, 60)
        return(f"{h:02d}h {m:02d}m remaining")    

def get_class(percentage=0, charging=False):
    if charging:
        return "charging"
    elif percentage == 0:
        return "critical"
    elif percentage <= 15:
        return "warning"
    elif percentage > 15 and percentage <= 30:
        return "bad"
    else:
        return "good"

if __name__ == "__main__":
    battery = psutil.sensors_battery()
    
    percentage = int(battery.percent)
    seconds = int(battery.secsleft)
    charging = battery.power_plugged
    
    icon = calculate_icon(percentage, charging)
    bar = render_ascii_bar(percentage, charging)
    
    text = f"{icon}  {bar}  {percentage}%"
    tooltip = f"{calculate_time_left(seconds, charging)}"

    css = get_class(percentage, charging)
    
    print(json.dumps({
        "text": text,
        "tooltip": tooltip,
        "class": css,
    })) 
    