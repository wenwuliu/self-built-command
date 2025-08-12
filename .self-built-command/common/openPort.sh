#!/bin/bash
# author:liuwenwu
# desc: Open firewall port safely
# create date:2022-02-16 15:34:37

set -e  # Exit on error

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage: openPort <port_number>" >&2
    echo "Open a TCP port in iptables firewall" >&2
    exit 1
fi

port="$1"

# Validate port number
if ! echo "$port" | grep -q '^[0-9]\+$'; then
    echo "Error: Invalid port number '$port'" >&2
    exit 1
fi

# Check port range
if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
    echo "Error: Port number must be between 1 and 65535" >&2
    exit 1
fi

# Check if iptables is available
if ! command -v iptables >/dev/null 2>&1; then
    echo "Error: iptables command not found" >&2
    exit 1
fi

echo "Opening TCP port $port..."

# Check if rule already exists
if sudo iptables -C INPUT -p tcp --dport "$port" -j ACCEPT 2>/dev/null; then
    echo "Port $port is already open"
    exit 0
fi

# Add the rule
if sudo iptables -I INPUT -p tcp --dport "$port" -j ACCEPT; then
    echo "Successfully opened port $port"
    
    # Save iptables rules
    if command -v iptables-save >/dev/null 2>&1; then
        if sudo iptables-save > /dev/null; then
            echo "Firewall rules saved"
        else
            echo "Warning: Failed to save firewall rules"
        fi
    else
        echo "Warning: iptables-save not found, rules may not persist after reboot"
    fi
else
    echo "Error: Failed to open port $port" >&2
    exit 1
fi