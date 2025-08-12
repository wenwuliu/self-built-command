#!/bin/bash
# author:liuwenwu
# desc: Safe delete with backup to garbage
# create date:2019-08-27 11:41:56

set -e  # Exit on error

garbage="$HOME/.self-built-command/.garbage"

# Create garbage directory if it doesn't exist
if [ ! -e "$garbage" ]; then
    mkdir -p "$garbage"
elif [ ! -d "$garbage" ]; then
    echo "Error: .garbage should be a directory" >&2
    exit 1
fi

# Create info directory if it doesn't exist
if [ ! -e "$garbage/.info" ]; then
    mkdir -p "$garbage/.info"
elif [ ! -d "$garbage/.info" ]; then
    echo "Error: .garbage/.info should be a directory" >&2
    exit 1
fi

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage: delete <file_or_directory>" >&2
    echo "Safely delete files by moving them to garbage with backup" >&2
    exit 1
fi

target="$1"

# Check if target exists
if [ ! -e "$target" ]; then
    echo "Error: file or directory '$target' does not exist" >&2
    exit 1
fi

# Get filename without trailing slash
fn="${target%*/}"
fn="${fn##*/}"

# Validate filename
if [ -z "$fn" ] || [ "$fn" = "." ] || [ "$fn" = ".." ]; then
    echo "Error: invalid filename '$fn'" >&2
    exit 1
fi

# Generate unique backup name if file already exists in garbage
backup_name="$fn"
counter=1
while [ -e "$garbage/${backup_name}.garbage" ]; do
    backup_name="${fn}_${counter}"
    counter=$((counter + 1))
done

echo "Backing up '$target' as '${backup_name}.garbage'..."

# Create backup with error handling
if tar -czf "${backup_name}.garbage" "$fn" 2>/dev/null; then
    # Get file size
    size=$(du -h --max-depth=0 "$target" 2>/dev/null | awk '{print $1}' || echo "unknown")
    
    # Get current date
    date=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Get absolute path
    if [ "${target:0:1}" = "/" ]; then
        pt="$target"
    else
        pt="$(pwd)/$target"
    fi
    
    # Remove original file/directory
    if rm -rf "$target"; then
        # Move backup to garbage
        if mv "${backup_name}.garbage" "$garbage/"; then
            # Save metadata
            {
                echo "size:$size"
                echo "name:$fn"
                echo "date:$date"
                echo "path:$pt"
            } > "$garbage/.info/${backup_name}.info"
            
            echo "Delete successful! Backup saved as ${backup_name}.garbage"
        else
            echo "Error: Failed to move backup to garbage directory" >&2
            exit 1
        fi
    else
        echo "Error: Failed to remove original file" >&2
        rm -f "${backup_name}.garbage" 2>/dev/null || true
        exit 1
    fi
else
    echo "Error: Failed to create backup archive" >&2
    exit 1
fi
