#!/bin/bash
# author:
# desc: Display formatted date and time
# create date:2022-03-23 16:53:45

# Default format
format="+%Y-%m-%d %H:%M:%S"

# Check for custom format argument
if [ $# -gt 0 ]; then
    case "$1" in
        -h|--help)
            echo "Usage: datetime [format]" >&2
            echo "Display current date and time" >&2
            echo "" >&2
            echo "Examples:" >&2
            echo "  datetime                    # Default: YYYY-MM-DD HH:MM:SS" >&2
            echo "  datetime '+%Y-%m-%d'        # Date only: YYYY-MM-DD" >&2
            echo "  datetime '+%H:%M:%S'        # Time only: HH:MM:SS" >&2
            echo "  datetime '+%s'              # Unix timestamp" >&2
            exit 0
            ;;
        +*)
            format="$1"
            ;;
        *)
            echo "Error: Format must start with '+'" >&2
            echo "Use 'datetime --help' for usage information" >&2
            exit 1
            ;;
    esac
fi

# Display formatted date
date "$format"
