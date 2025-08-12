#!/bin/bash
# author:liuwenwu
# desc: Connect to remote server
# create date:2020-10-22 17:05:49

# Default server (can be overridden by environment variable)
default_server="${REMOTE_SERVER_HOST:-192.168.100.194}"

# Check arguments
if [ $# -eq 0 ]; then
    server="$default_server"
elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: remote-server [server_address]" >&2
    echo "Connect to remote server via SSH" >&2
    echo "" >&2
    echo "Arguments:" >&2
    echo "  server_address  - Server IP or hostname (default: $default_server)" >&2
    echo "" >&2
    echo "Environment variables:" >&2
    echo "  REMOTE_SERVER_HOST - Default server address" >&2
    exit 0
else
    server="$1"
fi

# Validate server address
if [ -z "$server" ]; then
    echo "Error: Server address cannot be empty" >&2
    exit 1
fi

# Check if ssh is available
if ! command -v ssh >/dev/null 2>&1; then
    echo "Error: ssh command not found" >&2
    exit 1
fi

echo "Connecting to server: $server"

# Connect to server
ssh "$server"
