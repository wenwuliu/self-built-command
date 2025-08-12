#!/bin/bash
# author:liuwenwu
# desc: Kill processes by name with safety checks
# create date:2022-02-15 09:14:28

set -e  # Exit on error

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage: killPName <process_name>" >&2
    echo "Kill all processes matching the given name" >&2
    exit 1
fi

name="$1"

# Validate process name (basic security check)
if [ -z "$name" ] || echo "$name" | grep -q '[;&|`$()]'; then
    echo "Error: Invalid process name '$name'" >&2
    exit 1
fi

echo "Searching for processes matching '$name'..."

# Find matching processes, excluding grep and this script
pids=$(ps -ef | grep "$name" | grep -v grep | grep -v killPName | awk '{print $2}' || true)

if [ -z "$pids" ]; then
    echo "No processes found matching '$name'"
    exit 0
fi

echo "Found processes with PIDs: $pids"

# Show process details before killing
echo "Process details:"
ps -ef | grep "$name" | grep -v grep | grep -v killPName || true

# Ask for confirmation
echo -n "Kill these processes? [y/N]: "
read -r confirm
case "$confirm" in
    [yY]|[yY][eE][sS])
        echo "Killing processes..."
        ;;
    *)
        echo "Operation cancelled"
        exit 0
        ;;
esac

# Kill processes one by one with error handling
killed_count=0
failed_count=0

for pid in $pids; do
    # Validate PID is numeric
    if ! echo "$pid" | grep -q '^[0-9]\+$'; then
        echo "Warning: Invalid PID '$pid', skipping"
        failed_count=$((failed_count + 1))
        continue
    fi
    
    # Check if process still exists
    if ! kill -0 "$pid" 2>/dev/null; then
        echo "Process $pid no longer exists, skipping"
        continue
    fi
    
    # Try graceful kill first, then force kill
    if kill "$pid" 2>/dev/null; then
        echo "Sent TERM signal to process $pid"
        sleep 1
        
        # Check if process is still running
        if kill -0 "$pid" 2>/dev/null; then
            echo "Process $pid still running, sending KILL signal"
            if sudo kill -9 "$pid" 2>/dev/null; then
                echo "Force killed process $pid"
                killed_count=$((killed_count + 1))
            else
                echo "Failed to kill process $pid"
                failed_count=$((failed_count + 1))
            fi
        else
            echo "Process $pid terminated gracefully"
            killed_count=$((killed_count + 1))
        fi
    else
        echo "Failed to send signal to process $pid, trying force kill"
        if sudo kill -9 "$pid" 2>/dev/null; then
            echo "Force killed process $pid"
            killed_count=$((killed_count + 1))
        else
            echo "Failed to kill process $pid"
            failed_count=$((failed_count + 1))
        fi
    fi
done

echo "Summary: $killed_count processes killed, $failed_count failed"