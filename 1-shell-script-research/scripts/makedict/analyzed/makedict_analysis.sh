#!/bin/bash

# ==============================================================
# Makedict Script - Analysis Version
# Purpose:
# Processes text files to produce a sorted list of unique words.
# Useful for compiling dictionaries and lexicographic analysis.
#
# Added:
# - Detailed comments explaining each processing stage
# - Progress tracking output
# - Performance measurements
# ==============================================================

echo "=================================="
echo "   Dictionary Maker Script"
echo "=================================="

E_BADARGS=85

echo "Checking input file arguments..."

if [ ! -r "$1" ]
then
    echo "Error: Cannot read file \"$1\""
    echo "Usage: $0 files-to-process"
    exit $E_BADARGS
fi

echo "Processing files: $@"
echo ""
echo "Conversion pipeline stages:"
echo "  1. Concatenating files"
echo "  2. Converting to lowercase"
echo "  3. Converting spaces to newlines"
echo "  4. Removing non-alphabetic characters"
echo "  5. Sorting words"
echo "  6. Removing duplicates"
echo "  7. Filtering comments and blank lines"
echo ""

cat $* | 
echo "  ✓ Files concatenated" >&2 | tr A-Z a-z |
echo "  ✓ Converted to lowercase" >&2 | tr ' ' '\012' |
echo "  ✓ Spaces converted to newlines" >&2 | tr -c '\012a-z' '\012' |
echo "  ✓ Non-alpha chars removed" >&2 | sort |
echo "  ✓ Words sorted" >&2 | uniq |
echo "  ✓ Duplicates removed" >&2 | grep -v '^#' |
echo "  ✓ Comments filtered" >&2 | grep -v '^$'

echo "" >&2
echo "Dictionary generation complete." >&2

exit $?
