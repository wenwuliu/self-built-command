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
    
    # Process files in current directory
    for filepath in "$dir"/*; do
        # Skip if glob didn't match anything
        [ -e "$filepath" ] || continue
        
        filename="$(basename "$filepath")"
        
        # Skip hidden files
        case "$filename" in
            .*) continue ;;
        esac
        
        if [ -f "$filepath" ]; then
            suffix="${filename##*.}"
            basename="${filename%.*}"
            
            # Only create alias if basename is a valid identifier and not empty
            if [ -n "$basename" ] && echo "$basename" | grep -q '^[a-zA-Z_][a-zA-Z0-9_]*$' 2>/dev/null; then
                case "$suffix" in
                    sh|zsh)
                        if [ -x "$filepath" ]; then
                            alias "$basename"="$filepath" 2>/dev/null
                        fi
                        ;;
                    py)
                        # Check if python3 exists
                        if command -v python3 >/dev/null 2>&1; then
                            alias "$basename"="python3 '$filepath'" 2>/dev/null
                        fi
                        ;;
                    pybn)
                        if [ -x "$filepath" ]; then
                            alias "$basename"="$filepath" 2>/dev/null
                        fi
                        ;;
                esac
            fi
        elif [ -d "$filepath" ]; then
            # Recursively process subdirectories
            autoLoad "$filepath"
        fi
    done
}

if [ -d "$commandPath" ]; then
    autoLoad "$commandPath"
fi