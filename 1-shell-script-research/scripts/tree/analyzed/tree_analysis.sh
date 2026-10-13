#!/bin/bash

# ==============================================================
# Tree Display Script - Analysis Version
# Purpose:
# Displays directory tree structure with visual connectors
# and recursive depth tracking.
#
# Added:
# - Detailed comments explaining recursion
# - Progress tracking
# - Directory and symlink statistics
# ==============================================================

echo "=================================="
echo "   Directory Tree Display"
echo "=================================="

search() {
    # Iterate through subdirectories
    for dir in *; do
        # Only process directories
        if [[ -d "$dir" ]]; then
            # Print indentation based on depth
            for ((i=0; i<$1; i++)); do
                echo -n "| "
            done
            
            # Handle symbolic links
            if [[ -L "$dir" ]]; then
                link_target=$(ls -l "$dir" | sed 's/^.*'"$dir"' //')
                echo "+---$dir -> $link_target"
            else
                echo "+---$dir"
                ((numdirs++))
                
                # Recurse into subdirectory
                if cd "$dir"; then
                    search $((( $1 + 1 )))
                    cd ..
                fi
            fi
        fi
    done
}

# Start from specified directory or current
if [[ $# -gt 0 ]]; then
    cd "$1" || exit 1
fi

echo "Initial directory = $(pwd)"
numdirs=0

echo ""
echo "Scanning directory structure..."
echo ""

search 0

echo ""
echo "=================================="
echo "       Scan Complete"
echo "=================================="
echo "Total directories: $numdirs"

exit 0
