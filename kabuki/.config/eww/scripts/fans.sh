#!/usr/bin/env bash 

SMM='/dell_smm-virtual-0/,/^$/'

# Spinner frames
FRAMES=('/' '—' "\\" '|')

# Get fan RPM
get_rpm() {
    if [ "$1" == "1" ]; then
        sensors | awk "$SMM" | awk '/fan1/ {print $2}' | tr -cd '0-9'
    elif [ "$1" == "2" ]; then
        sensors | awk "$SMM" | awk '/fan2/ {print $2}' | tr -cd '0-9'
    fi
}

# Print current RPM only
if [ "$2" == "rpm" ]; then
    echo "$(get_rpm "$1") RPM"
    exit 0
fi

# Render spinning fan
render_fan() {
    local fan="$1"
    local i=0
    
    while true; do
        local rpm=$(get_rpm "$fan")
        local delay=$(( 500 - (rpm * 450 / 6800) ))
        if [ $delay -lt 50 ]; then
            delay=50
        fi

        if [ $rpm -eq "0" ]; then
            printf "[ %s ]\n" "—"
        else
            printf "[ %s ]\n" "${FRAMES[$i]}"
            i=$(( (i+1) % 4 ))
        fi
        
        # Force flush output for eww
        fflush stdout 2>/dev/null || true
        
        sleep "$(echo "scale=3; $delay/1000" | bc)"
    done
}

# JSON output with animated spinner
if [ "$2" == "json" ]; then
    rpm=$(get_rpm "$1")
    # Rotate through frames based on current time
    frame_idx=$(( ($(date +%s) / 1) % 4 ))
    if [ $rpm -eq "0" ]; then
        spinner="[ — ]"
    else
        spinner="[ ${FRAMES[$frame_idx]} ]"
    fi
    echo "{\"rpm\": \"$rpm RPM\", \"spinner\": \"$spinner\"}"
    exit 0
fi

# Run spinner if "fan" is requested
if [ "$2" == "fan" ]; then
    render_fan "$1"
fi