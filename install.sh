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

# Define current version
CURRENT_VERSION="v1.1.1"

# Check configuration status
has_config=false
installed_version=""
needs_update=false

if grep -q "load self built command" "$HOME/$shell_rc" 2>/dev/null; then
    has_config=true
    
    # Extract installed version
    installed_version=$(grep -A 1 "load self built command" "$HOME/$shell_rc" | grep "# version:" | sed 's/.*version: *//' | tr -d ' ')
    
    if [ -z "$installed_version" ]; then
        # No version found, this is an old version
        installed_version="unknown (old version)"
        needs_update=true
    elif [ "$installed_version" != "$CURRENT_VERSION" ]; then
        # Different version found
        needs_update=true
    fi
    
    if [ "$needs_update" = true ]; then
        echo "Found self-built-command configuration in $shell_rc"
        echo "  Installed version: $installed_version"
        echo "  Current version:   $CURRENT_VERSION"
        echo -n "Update configuration? [Y/n]: "
        read -r update_config
        case "$update_config" in
            [nN]|[nN][oO])
                echo "Keeping existing configuration"
                needs_update=false
                ;;
        esac
    else
        echo "self-built-command configuration is up to date ($CURRENT_VERSION) in $shell_rc"
    fi
fi

# Handle configuration installation/update
if [ "$has_config" = false ]; then
    # No configuration found, add new one
    echo "Adding self-built-command to $shell_rc..."
    echo "" >> "$HOME/$shell_rc"  # Add newline for safety
    cat loadSS.sh >> "$HOME/$shell_rc"
    echo "Configuration added to $shell_rc (version $CURRENT_VERSION)"
elif [ "$needs_update" = true ]; then
    # Update configuration
    echo "Updating configuration from $installed_version to $CURRENT_VERSION..."
    
    # Create backup
    backup_file="$HOME/${shell_rc}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$HOME/$shell_rc" "$backup_file"
    echo "Backup created: $backup_file"
    
    # Remove old self-built-command section
    awk '
    BEGIN { in_section = 0 }
    /^#load self built command$/ { 
        in_section = 1
        next
    }
    in_section && /^# version:/ {
        # Skip version line
        next
    }
    in_section && /^$/ {
        # Empty line might indicate end of section, check next line
        getline next_line
        if (next_line ~ /^[^#]/ && next_line !~ /^(commandPath=|if \[|autoLoad|fi$)/) {
            # This looks like user content, end of our section
            in_section = 0
            print ""  # Print the empty line we skipped
            print next_line
        }
        next
    }
    in_section && /^[^#]/ {
        # Skip all non-comment lines in our section
        next
    }
    !in_section { print }
    ' "$HOME/$shell_rc" > "$HOME/${shell_rc}.tmp"
    
    mv "$HOME/${shell_rc}.tmp" "$HOME/$shell_rc"
    
    # Add new configuration
    echo "" >> "$HOME/$shell_rc"
    cat loadSS.sh >> "$HOME/$shell_rc"
    echo "Configuration updated successfully to version $CURRENT_VERSION!"
fi

# Handle file installation
if [ -d ".self-built-command" ]; then
    if [ -d "$selfBuiltPath" ]; then
        echo "self-built-command directory already exists at $selfBuiltPath"
        echo -n "Do you want to update/reinstall? This will preserve your .garbage directory [y/N]: "
        read -r confirm
        case "$confirm" in
            [yY]|[yY][eE][sS])
                echo "Updating self-built-command files..."
                
                # Backup .garbage directory if it exists
                if [ -d "$selfBuiltPath/.garbage" ]; then
                    echo "Backing up .garbage directory..."
                    mv "$selfBuiltPath/.garbage" "$selfBuiltPath/.garbage.backup.$(date +%Y%m%d_%H%M%S)"
                fi
                
                # Copy new files
                if cp -r .self-built-command "$HOME/" 2>/dev/null; then
                    # Restore .garbage directory if backup exists
                    if [ -d "$selfBuiltPath/.garbage.backup."* ]; then
                        echo "Restoring .garbage directory..."
                        latest_backup=$(ls -1t "$selfBuiltPath"/.garbage.backup.* | head -n1)
                        mv "$latest_backup" "$selfBuiltPath/.garbage"
                    fi
                    echo "Update completed successfully!"
                else
                    echo "Error: Failed to copy files to $HOME/"
                    exit 1
                fi
                ;;
            *)
                echo "Installation skipped. Files at $selfBuiltPath remain unchanged."
                echo "Configuration in $shell_rc is up to date."
                exit 0
                ;;
        esac
    else
        echo "Installing self-built-command files..."
        if cp -r .self-built-command "$HOME/" 2>/dev/null; then
            echo "Installation completed successfully!"
        else
            echo "Error: Failed to copy files to $HOME/"
            exit 1
        fi
    fi
    
    # Set executable permissions
    echo "Setting executable permissions..."
    find "$selfBuiltPath" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    find "$selfBuiltPath" -name "*.pybn" -exec chmod +x {} \; 2>/dev/null || true
    
    echo "Please restart your shell or run: source ~/$shell_rc"
else
    echo "Error: .self-built-command directory not found"
    exit 1
fi