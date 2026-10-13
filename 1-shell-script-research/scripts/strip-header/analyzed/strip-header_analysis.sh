#!/bin/bash

# ==============================================================
# Strip Header Script - Analysis Version
# Purpose:
# Removes mail/News message headers (from start until first blank line)
# and filters out whitespace-only lines.
#
# Added:
# - Detailed comments explaining sed operations
# - Processing mode indicators
# - Execution flow tracking
# ==============================================================

echo "=================================="
echo "   Mail Header Stripper"
echo "=================================="

# sed expressions:
# 1,/^$/ - Delete lines 1 through first empty line
# /^[ ]*$/ - Match lines containing only spaces/tabs

echo "Header stripping pipeline:"
echo "  1. Deleting lines 1 to first blank line"
echo "  2. Removing whitespace-only lines"
echo ""

if [ $# -eq 0 ]; then
    echo "Processing from STDIN..."
    sed -e '1,/^$/d' -e '/^[ ]*$/d'
    echo "STDIN processing complete" >&2
else
    echo "Processing $# file(s)..."
    for i do
        echo "  Processing: $i" >&2
        sed -e '1,/^$/d' -e '/^[ ]*$/d' "$i"
        echo "  ✓ Completed: $i" >&2
    done
fi

echo "" >&2
echo "Header stripping complete." >&2

exit 0
