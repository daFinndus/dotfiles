#!/usr/bin/env bash

RAW_TARGET="/tmp/cava.fifo"

# Main stream processing - optimized for performance
while IFS=';' read -r -a values < "$RAW_TARGET"; do
    json="["
    for ((i=0; i<15; i++)); do
        [ $i -gt 0 ] && json+=","
        if [ $i -lt ${#values[@]} ]; then
            v=${values[i]//[^0-9]/}  # Strip non-digits
            if [ "${v:-0}" -eq 0 ]; then
                json+='"░"'
            else
                # Use printf to repeat characters efficiently
                printf -v bar '%*s' "$v" ''
                json+="\"${bar// /█}\""
            fi
        else
            # Pad with empty bars if not enough input values
            json+='"░"'
        fi
    done
    echo "$json]"
done