#!/usr/bin/env bash 

RAW_TARGET="/tmp/cava.fifo" 

# Stream cava values and convert to JSON arrays 
cat "$RAW_TARGET" | while read -r line; do 
    # Sanitize (keep only digits and ; and remove last ;) 
    clean=$(echo "$line" | tr -cd '0-9;') clean=${clean%;} 
    # replace semicolons with commas 
    json="[${clean//;/,}]" 
    echo "$json" 
done