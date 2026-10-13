#!/bin/bash

# ==============================================================
# Collatz Series Generator - Analysis Version
# Purpose:
# Generates the Collatz sequence (hailstone series) starting
# from a seed value. Applies the Collatz conjecture:
# - If even: divide by 2
# - If odd: multiply by 3 and add 1
# Continues until reaching 4→2→1 cycle or max iterations
#
# Added:
# - Detailed comments
# - Progress tracking
# - Mathematical explanation
# ==============================================================

echo "=================================="
echo "   Collatz Series Generator"
echo "=================================="

MAX_ITERATIONS=200
# Seed value: use command line arg or use current PID
h=${1:-$$}

echo "Seed value: $h"
echo "Maximum iterations: $MAX_ITERATIONS"
echo ""
echo "Starting Collatz sequence calculation..."
echo "C($h) -*- $MAX_ITERATIONS Iterations"
echo ""

iteration_count=0
min_value=$h
max_value=$h

for ((i=1; i<=MAX_ITERATIONS; i++))
do
    # Track min/max for statistical analysis
    [[ $h -lt $min_value ]] && min_value=$h
    [[ $h -gt $max_value ]] && max_value=$h
    
    # Print current value with formatting
    COLWIDTH=%7d
    printf $COLWIDTH $h
    
    # Calculate remainder to determine if even or odd
    let "remainder = h % 2"
    
    if [ "$remainder" -eq 0 ]
    then
        # Number is even - divide by 2
        let "h /= 2"
    else
        # Number is odd - multiply by 3 and add 1
        let "h = h*3 + 1"
    fi
    
    # Format output to 10 values per line
    COLUMNS=10
    let "line_break = i % $COLUMNS"
    if [ "$line_break" -eq 0 ]
    then
        echo ""
    fi
    
    ((iteration_count++))
done

echo ""
echo "=================================="
echo "       Calculation Complete"
echo "=================================="
echo "Iterations performed: $iteration_count"
echo "Minimum value reached: $min_value"
echo "Maximum value reached: $max_value"
echo ""

exit 0
