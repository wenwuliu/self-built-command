#!/bin/bash
# author:liuwenwu
# desc:make touch more personal
# create date :2019-08-27 11:34:11

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage: touch <filename>" >&2
    echo "Enhanced touch command with template support" >&2
    exit 1
fi

filename="$1"

# Validate filename
if [ -z "$filename" ] || echo "$filename" | grep -q '[;&|`$()]'; then
    echo "Error: Invalid filename '$filename'" >&2
    exit 1
fi

# Extract suffix and prefix
suf="${filename##*.}"
pref="${filename%.*}"

# Get current shell, fallback to bash if not set
sh="${SHELL:-/bin/bash}"

case "$suf" in
    sh|zsh)
        touch "$filename"
        time=$(date "+%Y-%m-%d %H:%M:%S")
        {
            echo "#!$sh"
            echo "# author:"
            echo "# desc:"
            echo "# create date:$time"
        } >> "$filename"
        chmod +x "$filename"
        echo "Created executable shell script: $filename"
        ;;
    desktop)
        touch "$filename"
        # Use environment variables for paths, with fallbacks
        icon_path="${SELF_BUILT_ICON_PATH:-$HOME/.local/share/icons/unknown.png}"
        exec_path="${SELF_BUILT_EXEC_PATH:-$HOME/bin/}"
        
        {
            echo "[Desktop Entry]"
            echo "Type=Application"
            echo "Name=$pref"
            echo "GenericName=$pref"
            echo "Icon=$icon_path"
            echo "Exec=$exec_path"
            echo "Terminal=false"
            echo "Categories=selfbuilt;other"
            echo "Keywords="
        } >> "$filename"
        echo "Created desktop entry: $filename"
        echo "Note: Update Icon and Exec paths as needed"
        ;;
    *)
        touch "$filename"
        echo "Created file: $filename"
        ;;
esac
