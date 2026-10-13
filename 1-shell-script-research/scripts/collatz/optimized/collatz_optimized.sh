#!/bin/bash

# Optimized Collatz Series Generator
# Generates Collatz sequence with improved performance

MAX_ITERATIONS=200
h=${1:-$$}
COLUMNS_PER_LINE=10
COL_WIDTH=7

echo "C($h) -*- $MAX_ITERATIONS Iterations"
echo ""

for ((i=1; i<=MAX_ITERATIONS; i++)); do
    printf "%${COL_WIDTH}d" "$h"
    
    # Bitwise operation faster than modulo for checking odd/even
    if (( h & 1 )); then
        # Odd: multiply by 3 and add 1
        h=$((h*3 + 1))
    else
        # Even: divide by 2
        h=$((h >> 1))
    fi
    
    # New line every COLUMNS_PER_LINE values
    (( i % COLUMNS_PER_LINE == 0 )) && echo ""
done

echo ""
exit 0
