#!/bin/bash
# author:
# desc: 创建desktop文件
# create date:2022-03-31 09:40:41

# Check arguments
if [ $# -lt 2 ]; then
    echo "Usage: createDesktop <desktopName> <executeCommand> [icon.png] [keywords]" >&2
    echo "Create a desktop entry file" >&2
    echo "" >&2
    echo "Arguments:" >&2
    echo "  desktopName     - Name of the application" >&2
    echo "  executeCommand  - Command to execute" >&2
    echo "  icon.png        - Path to icon file (optional)" >&2
    echo "  keywords        - Semicolon-separated keywords (optional)" >&2
    echo "" >&2
    echo "Example:" >&2
    echo "  createDesktop myapp ~/shells/test.sh ~/shells/unknown.png 'tools;test;'" >&2
    exit 1
fi

desktop_name="$1"
exec_command="$2"
icon_path="$3"
keywords="$4"

# Validate desktop name
if [ -z "$desktop_name" ] || echo "$desktop_name" | grep -q '[/\\]'; then
    echo "Error: Invalid desktop name '$desktop_name'" >&2
    exit 1
fi

# Validate execute command
if [ -z "$exec_command" ]; then
    echo "Error: Execute command cannot be empty" >&2
    exit 1
fi

# Create applications directory if it doesn't exist
apps_dir="$HOME/.local/share/applications"
if [ ! -d "$apps_dir" ]; then
    mkdir -p "$apps_dir"
    echo "Created directory: $apps_dir"
fi

desktop_file="$apps_dir/$desktop_name.desktop"

# Check if file already exists
if [ -f "$desktop_file" ]; then
    echo -n "Desktop file '$desktop_file' already exists. Overwrite? [y/N]: "
    read -r confirm
    case "$confirm" in
        [yY]|[yY][eE][sS]) ;;
        *) echo "Operation cancelled"; exit 0 ;;
    esac
fi

# Set default icon if not provided
if [ -z "$icon_path" ]; then
    icon_path="${SELF_BUILT_ICON_PATH:-$HOME/.local/share/icons/unknown.png}"
fi

# Create desktop file
echo "Creating desktop file: $desktop_file"

{
    echo "[Desktop Entry]"
    echo "Type=Application"
    echo "Name=$desktop_name"
    echo "GenericName=$desktop_name"
    echo "Icon=$icon_path"
    echo "Exec=$exec_command"
    echo "Terminal=false"
    echo "Categories=selfbuilt;other"
    echo "Keywords=selfbuilt;$keywords"
} > "$desktop_file"

# Make it executable
chmod +x "$desktop_file"

echo "Desktop file created successfully!"
echo "File location: $desktop_file"

# Verify the desktop file
if desktop-file-validate "$desktop_file" 2>/dev/null; then
    echo "Desktop file validation: PASSED"
else
    echo "Warning: Desktop file validation failed, but file was created"
fi
