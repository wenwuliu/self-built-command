#load self built command
commandPath="$HOME/.self-built-command"

# Create directory if it doesn't exist
if [ ! -e "$commandPath" ]; then
    mkdir -p "$commandPath"
fi

autoLoad(){
    local dir="$1"
    
    # Check if directory exists and is readable
    if [ ! -d "$dir" ] || [ ! -r "$dir" ]; then
        return
    fi
    
    # Use find instead of ls for better handling of filenames with spaces
    find "$dir" -maxdepth 1 -type f -o -type d | while IFS= read -r filepath; do
        # Skip the directory itself
        [ "$filepath" = "$dir" ] && continue
        
        local filename
        filename="$(basename "$filepath")"
        
        # Skip hidden files
        case "$filename" in
            .*) continue ;;
        esac
        
        if [ -f "$filepath" ]; then
            local suffix="${filename##*.}"
            local basename="${filename%.*}"
            
            # Only create alias if basename is a valid identifier
            if echo "$basename" | grep -q '^[a-zA-Z_][a-zA-Z0-9_]*$'; then
                case "$suffix" in
                    sh|zsh)
                        if [ -x "$filepath" ]; then
                            alias "$basename"="$filepath"
                        fi
                        ;;
                    py)
                        # Check if python3 exists
                        if command -v python3 >/dev/null 2>&1; then
                            alias "$basename"="python3 '$filepath'"
                        fi
                        ;;
                    pybn)
                        if [ -x "$filepath" ]; then
                            alias "$basename"="$filepath"
                        fi
                        ;;
                esac
            fi
        elif [ -d "$filepath" ]; then
            autoLoad "$filepath"
        fi
    done
}

if [ -d "$commandPath" ]; then
    autoLoad "$commandPath"
else
    echo "Warning: $commandPath is not a directory" >&2
fi