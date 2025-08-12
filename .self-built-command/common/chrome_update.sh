#!/bin/bash
# author:
# desc: Update Google Chrome to latest version
# create date:2022-09-27 09:09:40

set -e  # Exit on error

package_name="google-chrome-stable_current_amd64.deb"
download_url="https://dl.google.com/linux/direct/$package_name"

echo "Updating Google Chrome..."

# Check if wget is available
if ! command -v wget >/dev/null 2>&1; then
    echo "Error: wget is required but not installed" >&2
    exit 1
fi

# Check if dpkg is available
if ! command -v dpkg >/dev/null 2>&1; then
    echo "Error: dpkg is required but not installed" >&2
    exit 1
fi

# Remove existing package if present
if [ -f "$package_name" ]; then
    echo "Removing existing package..."
    rm -f "$package_name"
fi

# Download latest package
echo "Downloading latest Chrome package..."
if wget "$download_url"; then
    echo "Download completed"
else
    echo "Error: Failed to download Chrome package" >&2
    exit 1
fi

# Install package
echo "Installing Chrome package..."
if sudo dpkg -i "./$package_name"; then
    echo "Chrome installation completed"
else
    echo "Installation may have dependency issues, trying to fix..."
    sudo apt-get install -f
fi

# Clean up
echo "Cleaning up..."
rm -f "$package_name"

echo "Chrome update completed successfully!"
