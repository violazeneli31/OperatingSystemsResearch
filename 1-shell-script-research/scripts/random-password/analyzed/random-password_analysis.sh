#!/bin/bash

# ==============================================================
# Random Password Generator - Analysis Version
# Purpose:
# Generates a random alphanumeric password of configurable length.
# Uses $RANDOM for pseudo-random number generation.
#
# Added:
# - Detailed comments explaining logic
# - Progress display
# - Configuration information
# ==============================================================

echo "=================================="
echo "   Random Password Generator"
echo "=================================="

MATRIX="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
LENGTH="${1:-8}"

echo "Configuration:"
echo "  Character set: $MATRIX"
echo "  Character set size: ${#MATRIX}"
echo "  Password length: $LENGTH characters"
echo ""
echo "Generating password..."
echo ""

n=1
PASS=""

while [ $n -le "$LENGTH" ]
do
    # Select random position in character set
    random_index=$(($RANDOM % ${#MATRIX}))
    
    # Extract single character at that position
    random_char="${MATRIX:$random_index:1}"
    
    # Append to password
    PASS="$PASS$random_char"
    
    # Visual progress
    echo -ne "  Progress: [$n/$LENGTH] \r" >&2
    
    # Increment counter
    ((n++))
done

echo "" >&2
echo "=================================="
echo "Generated Password"
echo "=================================="
echo "$PASS"
echo ""
echo "Password Details:"
echo "  Length: ${#PASS} characters"
echo "  Character types: Letters (52) + Numbers (10)"

exit 0
