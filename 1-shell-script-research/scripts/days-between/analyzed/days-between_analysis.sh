#!/bin/bash

# ==============================================================
# Days Between Dates - Analysis Version
# Purpose:
# Calculates the number of days between two dates using
# Gauss' Formula for efficient date arithmetic.
#
# Added:
# - Detailed comments explaining date calculations
# - Debug output at each step
# - Intermediate variable tracking
# ==============================================================

echo "=================================="
echo "  Days Between Dates Calculator"
echo "=================================="

ARGS=2
E_PARAM_ERR=85
REFYR=1600
CENTURY=100
DIY=365
ADJ_DIY=367
MIY=12
DIM=31
LEAPCYCLE=4

# Global variables
diff=0
value=0
day=0
month=0
year=0

echo "Script started with $# arguments"
echo ""

Param_Error() {
    echo "Error: Invalid parameters"
    echo "Usage: $(basename $0) [M]M/[D]D/YYYY [M]M/[D]D/YYYY"
    echo " (dates must be after 1/3/1600)"
    exit $E_PARAM_ERR
}

Parse_Date() {
    echo "  Parsing date: $1"
    month=${1%%/**}
    dm=${1%/**}
    day=${dm#*/}
    year=$(basename "$1" 2>/dev/null)
    echo "    Month: $month, Day: $day, Year: $year"
}

check_date() {
    if [ "$day" -gt "$DIM" ] || [ "$month" -gt "$MIY" ] || [ "$year" -lt "$REFYR" ]
    then
        echo "Error: Invalid date detected"
        Param_Error
    fi
}

strip_leading_zero() {
    result=${1#0}
    [[ -z "$result" ]] && result=0
    echo "$result"
}

day_index() {
    local d=$1 m=$2 y=$3
    echo "    Calculating day index for: $m/$d/$y"
    
    m=$((m - 2))
    if [ "$m" -le 0 ]; then
        m=$((m + 12))
        y=$((y - 1))
    fi
    
    y=$((y - REFYR))
    local indexyr=$((y / CENTURY))
    local Days=$((DIY*y + y/LEAPCYCLE - indexyr + indexyr/LEAPCYCLE + ADJ_DIY*m/MIY + d - DIM))
    
    echo "    Calculated day index: $Days"
    echo "$Days"
}

calculate_difference() {
    diff=$((date1 - date2))
    echo "  Difference calculated: $diff"
}

abs() {
    if [ "$1" -lt 0 ]; then
        value=$((0 - $1))
    else
        value=$1
    fi
    echo "  Absolute value: $value"
}

# Main execution
echo "Validating arguments..."
if [ $# -ne "$ARGS" ]; then
    Param_Error
fi

echo ""
echo "Processing first date: $1"
Parse_Date "$1"
check_date

day=$(strip_leading_zero "$day")
month=$(strip_leading_zero "$month")
echo "  After zero-strip: $month/$day/$year"
date1=$(day_index "$day" "$month" "$year")

echo ""
echo "Processing second date: $2"
Parse_Date "$2"
check_date

day=$(strip_leading_zero "$day")
month=$(strip_leading_zero "$month")
echo "  After zero-strip: $month/$day/$year"
date2=$(day_index "$day" "$month" "$year")

echo ""
echo "Calculating difference..."
calculate_difference
abs "$diff"
diff=$value

echo ""
echo "=================================="
echo "          Final Result"
echo "=================================="
echo "Days between dates: $diff"
echo ""

exit 0
