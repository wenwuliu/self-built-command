#!/bin/bash
# author:liuwenwu
# desc: Uninstall self-built-command tools
# create date:2024-08-12

set -e  # Exit on error

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

echo "Uninstalling self-built-command..."

# Remove configuration from shell rc file
if [ -f "$HOME/$shell_rc" ]; then
    echo "Removing configuration from $shell_rc..."
    
    # Create backup
    cp "$HOME/$shell_rc" "$HOME/${shell_rc}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backup created: $HOME/${shell_rc}.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Remove the self-built-command section
    if grep -q "load self built command" "$HOME/$shell_rc"; then
        # Create temporary file without self-built-command section
        awk '
        /^#load self built command$/ { skip=1; next }
        skip && /^$/ && getline ~ /^[^#]/ { skip=0 }
        skip && /^[^#]/ { next }
        !skip { print }
        ' "$HOME/$shell_rc" > "$HOME/${shell_rc}.tmp"
        
        mv "$HOME/${shell_rc}.tmp" "$HOME/$shell_rc"
        echo "Configuration removed from $shell_rc"
    else
        echo "No self-built-command configuration found in $shell_rc"
    fi
else
    echo "Shell configuration file $HOME/$shell_rc not found"
fi

# Ask about removing files
if [ -d "$selfBuiltPath" ]; then
    echo -n "Remove self-built-command files from $selfBuiltPath? [y/N]: "
    read -r confirm
    case "$confirm" in
        [yY]|[yY][eE][sS])
            echo "Removing files..."
            rm -rf "$selfBuiltPath"
            echo "Files removed successfully"
            ;;
        *)
            echo "Files kept at $selfBuiltPath"
            ;;
    esac
else
    echo "Directory $selfBuiltPath not found"
fi

# Remove aliases from current session
echo "Removing aliases from current session..."
unalias delete 2>/dev/null || true
unalias touch 2>/dev/null || true
unalias killPName 2>/dev/null || true
unalias openPort 2>/dev/null || true
unalias datetime 2>/dev/null || true
unalias autoArrange 2>/dev/null || true
unalias autoReply 2>/dev/null || true
unalias createDesktop 2>/dev/null || true
unalias screenConnect 2>/dev/null || true
unalias bash2048 2>/dev/null || true

echo ""
echo "Uninstallation completed!"
echo "Please restart your shell or run: source ~/$shell_rc"
echo ""
echo "Note: If you want to completely remove all traces:"
echo "1. Check for any remaining aliases: alias | grep self-built"
echo "2. Remove any custom environment variables you may have set"
echo "3. Check ~/.local/share/applications/ for any desktop files created"