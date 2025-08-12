#!/bin/bash
# author:
# desc: Manage external screen connections
# create date:2022-04-18 17:09:06

# Check if xrandr is available
if ! command -v xrandr >/dev/null 2>&1; then
    echo "Error: xrandr command not found" >&2
    exit 1
fi

# Show help
show_help() {
    echo "Usage: screenConnect <command> [device_name]" >&2
    echo "Manage external screen connections" >&2
    echo "" >&2
    echo "Commands:" >&2
    echo "  show              - Show all screen devices" >&2
    echo "  on <device_name>  - Connect to device" >&2
    echo "  off <device_name> - Disconnect from device" >&2
    echo "" >&2
    echo "Examples:" >&2
    echo "  screenConnect show" >&2
    echo "  screenConnect on HDMI-1" >&2
    echo "  screenConnect off HDMI-1" >&2
}

# Check arguments
if [ $# -eq 0 ] || [ "$1" = "help" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

command="$1"
device="$2"

case "$command" in
    show)
        echo "Available displays:"
        xrandr
        ;;
    on)
        if [ -z "$device" ]; then
            echo "Error: Device name required for 'on' command" >&2
            show_help
            exit 1
        fi
        
        # Validate device exists
        if ! xrandr | grep -q "^$device "; then
            echo "Error: Device '$device' not found" >&2
            echo "Available devices:"
            xrandr | grep " connected\|disconnected" | awk '{print $1}'
            exit 1
        fi
        
        echo "Connecting display: $device"
        if xrandr --output "$device" --right-of eDP-1 --auto; then
            echo "Display '$device' connected successfully"
        else
            echo "Error: Failed to connect display '$device'" >&2
            exit 1
        fi
        ;;
    off)
        if [ -z "$device" ]; then
            echo "Error: Device name required for 'off' command" >&2
            show_help
            exit 1
        fi
        
        echo "Disconnecting display: $device"
        if xrandr --output "$device" --off; then
            echo "Display '$device' disconnected successfully"
        else
            echo "Error: Failed to disconnect display '$device'" >&2
            exit 1
        fi
        ;;
    *)
        echo "Error: Unknown command '$command'" >&2
        show_help
        exit 1
        ;;
esac

