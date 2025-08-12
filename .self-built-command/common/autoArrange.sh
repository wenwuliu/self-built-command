#!/bin/bash
# author:
# desc: Auto arrange files by type
# create date:2022-03-30 09:35:36

set -e  # Exit on error

# Default path
p="$HOME/Downloads/"

# Use provided path if given
if [ $# -gt 0 ] && [ -n "$1" ]; then
    p="$1"
    # Ensure path ends with /
    case "$p" in
        */) ;;
        *) p="$p/" ;;
    esac
fi

# Validate directory
if [ ! -d "$p" ]; then
    echo "Error: Directory '$p' does not exist" >&2
    exit 1
fi

if [ ! -w "$p" ]; then
    echo "Error: Directory '$p' is not writable" >&2
    exit 1
fi

echo "Organizing files in: $p"

# Change to target directory
cd "$p" || exit 1

# Define directories and their corresponding file extensions
dirs=("applications" "documents" "fonts" "pictures" "isos" "zips")
suf1='deb exe AppImage apk'
suf2='pdf xlsx docx xls doc ppt pptx'
suf3='ttf'
suf4='svg jpg png jpeg bmp gif'
suf5='img dmg iso'
suf6='zip rar tar.gz tar.xz jar arj'

# Create directories if they don't exist
for dir in "${dirs[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Created directory: $dir"
    fi
done

# Function to safely move files
move_files() {
    local target_dir="$1"
    local extension="$2"
    local moved_count=0
    
    # Handle special case for compound extensions
    if [ "$extension" = "tar.gz" ] || [ "$extension" = "tar.xz" ]; then
        for file in *."$extension"; do
            [ -f "$file" ] || continue
            
            # Check if target file already exists
            if [ -f "$target_dir/$file" ]; then
                echo "Warning: $target_dir/$file already exists, skipping $file"
                continue
            fi
            
            if mv "$file" "$target_dir/" 2>/dev/null; then
                echo "Moved: $file -> $target_dir/"
                moved_count=$((moved_count + 1))
            else
                echo "Warning: Failed to move $file"
            fi
        done
    else
        for file in *."$extension"; do
            [ -f "$file" ] || continue
            
            # Check if target file already exists
            if [ -f "$target_dir/$file" ]; then
                echo "Warning: $target_dir/$file already exists, skipping $file"
                continue
            fi
            
            if mv "$file" "$target_dir/" 2>/dev/null; then
                echo "Moved: $file -> $target_dir/"
                moved_count=$((moved_count + 1))
            else
                echo "Warning: Failed to move $file"
            fi
        done
    fi
    
    return $moved_count
}

# Process each category
total_moved=0

for k in $(seq 1 ${#dirs[@]}); do
    dir="${dirs[$((k-1))]}"
    suf_var="suf$k"
    
    # Get the extensions for this category
    case $k in
        1) extensions="$suf1" ;;
        2) extensions="$suf2" ;;
        3) extensions="$suf3" ;;
        4) extensions="$suf4" ;;
        5) extensions="$suf5" ;;
        6) extensions="$suf6" ;;
    esac
    
    echo "Processing $dir category..."
    
    # Process each extension in this category
    for ext in $extensions; do
        move_files "$dir" "$ext"
        moved=$?
        total_moved=$((total_moved + moved))
    done
done

echo "Organization complete! Total files moved: $total_moved"

# Show summary
echo ""
echo "Directory summary:"
for dir in "${dirs[@]}"; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -maxdepth 1 -type f | wc -l)
        echo "  $dir: $count files"
    fi
done