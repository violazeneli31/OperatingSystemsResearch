#!/bin/bash

# Optimized Blank-Rename Script
# Replaces spaces with underscores in filenames

count=0

# Use nullglob to safely handle no matches
shopt -s nullglob

for filename in *; do
    # Check if filename contains spaces
    if [[ "$filename" =~ " " ]]; then
        # Replace spaces with underscores using parameter expansion
        new_filename="${filename// /_}"
        
        if [[ "$filename" != "$new_filename" ]]; then
            mv "$filename" "$new_filename" 2>/dev/null && ((count++))
        fi
    fi
done

# Output result with correct grammar
if [[ $count -eq 1 ]]; then
    echo "$count file renamed."
else
    echo "$count files renamed."
fi
