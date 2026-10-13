#!/bin/bash

# Optimized Days Between Dates Calculator
# Using improved parameter handling and modern Bash features

[[ $# -ne 2 ]] && {
    echo "Usage: $(basename "$0") MM/DD/YYYY MM/DD/YYYY"
    exit 85
}

readonly REFYR=1600
readonly CENTURY=100
readonly DIY=365
readonly ADJ_DIY=367
readonly MIY=12
readonly DIM=31
readonly LEAPCYCLE=4

parse_date() {
    local date=$1
    IFS='/' read -r m d y <<< "$date"
    # Remove leading zeros
    m=$((10#$m))
    d=$((10#$d))
    y=$((10#$y))
}

day_index() {
    local m=$1 d=$2 y=$3
    
    ((m -= 2))
    if (( m <= 0 )); then
        ((m += 12))
        ((y -= 1))
    fi
    
    ((y -= REFYR))
    local indexyr=$((y / CENTURY))
    local days=$((DIY*y + y/LEAPCYCLE - indexyr + indexyr/LEAPCYCLE + ADJ_DIY*m/MIY + d - DIM))
    
    echo "$days"
}

parse_date "$1"
date1=$(day_index "$m" "$d" "$y")

parse_date "$2"
date2=$(day_index "$m" "$d" "$y")

# Calculate absolute difference
diff=$(( date1 > date2 ? date1 - date2 : date2 - date1 ))
echo "$diff"
