#!/bin/bash

# Optimized RN (Rename) Script
# Simple batch file renaming utility with improved practices

ARGS=2
E_BADARGS=85
ONE=1

if [[ $# -ne $ARGS ]]; then
    echo "Usage: $(basename "$0") old-pattern new-pattern"
    echo "Example: $(basename "$0") gif jpg"
    exit $E_BADARGS
fi

old_pattern="$1"
new_pattern="$2"
count=0

# Safely process matching files
shopt -s nullglob

for filename in *"$old_pattern"*; do
    [[ -f "$filename" ]] || continue
    
    # Use parameter expansion instead of basename/sed
    new_filename="${filename//$old_pattern/$new_pattern}"
    
    if [[ "$filename" != "$new_filename" ]]; then
        mv "$filename" "$new_filename" 2>/dev/null && ((count++))
    fi
done

# Output result with correct grammar
if [[ $count -eq $ONE ]]; then
    echo "$count file renamed."
else
    echo "$count files renamed."
fi

exit 0
