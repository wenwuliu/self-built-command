#!/bin/bash
# author:liuwenwu
# desc: Install self-built-command tools
# create date:2019-08-29 09:54:41

set -e  # Exit on any error

shell_name="${SHELL##*/}"
selfBuiltPath="$HOME/.self-built-command"

# Determine shell configuration file
if [ "$shell_name" = "zsh" ]; then
    shell_rc=".zshrc"
elif [ "$shell_name" = "bash" ]; then
    shell_rc=".bashrc"
else
    echo "Warning: Unsupported shell '$shell_name', defaulting to .bashrc"
    shell_rc=".bashrc"
fi

# Check if configuration file exists
if [ ! -f "$HOME/$shell_rc" ]; then
    echo "Creating $shell_rc file..."
    touch "$HOME/$shell_rc"
fi

# Check if already installed (more robust check)
if ! grep -q "load self built command" "$HOME/$shell_rc" 2>/dev/null; then
    echo "Adding self-built-command to $shell_rc..."
    echo "" >> "$HOME/$shell_rc"  # Add newline for safety
    cat loadSS.sh >> "$HOME/$shell_rc"
    echo "Configuration added to $shell_rc"
else
    echo "self-built-command already configured in $shell_rc"
fi

# Copy files with error handling
if [ -d ".self-built-command" ]; then
    echo "Installing self-built-command files..."
    if cp -r .self-built-command "$HOME/" 2>/dev/null; then
        echo "Installation completed successfully!"
        echo "Please restart your shell or run: source ~/$shell_rc"
    else
        echo "Error: Failed to copy files to $HOME/"
        exit 1
    fi
else
    echo "Error: .self-built-command directory not found"
    exit 1
fi