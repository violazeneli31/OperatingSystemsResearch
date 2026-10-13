#!/bin/bash

# Optimized Tree Display Script
# More efficient directory traversal and display

DEPTH=0
TOTAL_DIRS=0

search() {
    local indent=$1
    local prefix=""
    
    # Build indentation string
    for ((i=0; i<indent; i++)); do
        prefix+="  "
    done
    
    for dir in */; do
        dir="${dir%/}"  # Remove trailing slash
        
        if [[ -L "$dir" ]]; then
            echo "${prefix}├── $dir -> $(readlink "$dir")"
        else
            echo "${prefix}├── $dir/"
            ((TOTAL_DIRS++))
            
            if cd "$dir" 2>/dev/null; then
                search $((indent+1))
                cd ..
            fi
        fi
    done
}

start_dir="${1:-.}"

if [[ ! -d "$start_dir" ]]; then
    echo "Error: Directory not found: $start_dir"
    exit 1
fi

cd "$start_dir" || exit 1

echo "Directory tree for: $(pwd)"
echo ""

search 0

echo ""
echo "Total subdirectories: $TOTAL_DIRS"
exit 0
