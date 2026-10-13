#!/bin/bash

# ==============================================================
# Blank-Rename Script - Analysis Version
# Purpose:
# Finds all files in the current directory that contain spaces
# in their names and replaces those spaces with underscores.
#
# Added:
# - Detailed comments explaining logic
# - Intermediate output for tracking
# - Execution trace for analysis
# ==============================================================

echo "=================================="
echo "   Blank-Rename Script Started"
echo "=================================="

ONE=1
number=0
FOUND=0  # Successful return value for grep

echo "Searching for files with spaces in names..."
echo "Current directory: $(pwd)"
echo ""

# Process each file in current directory
for filename in *
do
    echo "Checking: $filename"
    
    # Use grep to check if filename contains spaces
    echo "$filename" | grep -q " "
    grep_result=$?
    
    if [ $grep_result -eq $FOUND ]
    then
        echo "  → Contains spaces (grep returned $grep_result)"
        fname=$filename
        echo "  Original name: $fname"
        
        # Substitute spaces with underscores using sed
        n=`echo $fname | sed -e "s/ /_/g"`
        echo "  New name: $n"
        
        # Perform the renaming
        mv "$fname" "$n"
        echo "  Rename completed"
        
        let "number += 1"
        echo "  Total files renamed so far: $number"
    else
        echo "  → No spaces found (grep returned $grep_result)"
    fi
    echo ""
done

echo "=================================="
echo "     Renaming Operation Complete"
echo "=================================="

# Output summary with correct grammar
if [ "$number" -eq "$ONE" ]
then
    echo "Result: $number file renamed."
else
    echo "Result: $number files renamed."
fi
