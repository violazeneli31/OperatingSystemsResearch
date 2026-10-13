#!/bin/bash

# ==============================================================
# RN (Rename) Script - Analysis Version
# Purpose:
# A simple batch file renaming utility that searches for files
# matching a pattern and renames them based on substitution rules.
#
# Added:
# - Detailed comments explaining each section
# - Echo statements for tracking execution flow
# - Debugging output for pattern matching
# ==============================================================

echo "=================================="
echo "   RN (Rename) Script Started"
echo "=================================="

ARGS=2
E_BADARGS=85
ONE=1

echo "Script requires $ARGS arguments"
echo "Argument 1 (pattern to find): $1"
echo "Argument 2 (replacement text): $2"

# Validate arguments
if [ $# -ne "$ARGS" ]
then
    echo "Error: Incorrect number of arguments (got $#, need $ARGS)"
    echo "Usage: `basename $0` old-pattern new-pattern"
    echo "Example: `basename $0` gif jpg"
    exit $E_BADARGS
fi

echo "Argument validation passed"
echo ""
echo "Searching for files matching pattern: *$1*"

number=0 # Counter for renamed files

# Main loop: iterate through matching files
for filename in *$1*
do
    echo "Found match: $filename"
    
    # Check if it's a regular file (not directory)
    if [ -f "$filename" ]
    then
        echo "  Processing file: $filename"
        fname=`basename $filename`
        echo "  Basename extracted: $fname"
        
        # Generate new filename
        n=`echo $fname | sed -e "s/$1/$2/"`
        echo "  New filename will be: $n"
        
        # Perform the rename
        mv $fname $n
        echo "  Successfully renamed to: $n"
        
        let "number += 1"
        echo "  Total files renamed so far: $number"
        echo ""
    else
        echo "  Skipping (not a regular file): $filename"
    fi
done

echo "=================================="
echo "       Rename Operation Complete"
echo "=================================="

# Output result summary
if [ "$number" -eq "$ONE" ]
then
    echo "Result: $number file renamed."
else
    echo "Result: $number files renamed."
fi

exit $?
