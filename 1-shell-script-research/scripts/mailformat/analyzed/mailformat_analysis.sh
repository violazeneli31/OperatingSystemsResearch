#!/bin/bash

# ==============================================================
# Mail Format Script - Analysis Version
# Purpose:
# This script removes unwanted characters from an email text file
# and formats long lines to improve readability.
#
# Added:
# - Detailed comments
# - Intermediate echo outputs
# - Execution tracing for research analysis
# ==============================================================


echo "=================================="
echo " Mail Format Script Started"
echo "=================================="


# --------------------------------------------------------------
# Check if the correct number of arguments was provided
# The script requires exactly one input file
# --------------------------------------------------------------

ARGS=1

E_BADARGS=85
E_NOFILE=86


echo "Checking script arguments..."

if [ $# -ne $ARGS ]
then

    echo "Error: Incorrect number of arguments"
    echo "Usage: $(basename $0) filename"

    exit $E_BADARGS

fi


echo "Argument received:"
echo "$1"



# --------------------------------------------------------------
# Check if the provided file exists
# --------------------------------------------------------------

echo "Checking if file exists..."


if [ -f "$1" ]

then

    file_name=$1

    echo "File found:"
    echo "$file_name"


else

    echo "File does not exist:"
    echo "$1"

    exit $E_NOFILE

fi



# --------------------------------------------------------------
# Maximum line width after formatting
# --------------------------------------------------------------

MAXWIDTH=70


echo "Maximum line width:"
echo "$MAXWIDTH"



# --------------------------------------------------------------
# Create sed processing rules
#
# Operations:
# 1. Remove > characters
# 2. Remove spaces before text
# 3. Remove leading spaces
# 4. Remove trailing spaces
# --------------------------------------------------------------


echo "Preparing text cleaning rules..."


sedscript='s/^>//
s/^ *>//
s/^ *//
s/ *//'


echo "Cleaning rules created"



# --------------------------------------------------------------
# Apply formatting:
#
# sed:
# Removes unwanted characters
#
# fold:
# Breaks long lines into smaller pieces
# --------------------------------------------------------------


echo "Starting text processing..."

echo "Original file content:"
cat "$1"


echo "----------------------------------"
echo "Formatted output:"
echo "----------------------------------"


sed "$sedscript" "$1" | fold -s --width=$MAXWIDTH



echo "=================================="
echo " Mail Format Script Finished"
echo "=================================="


exit $?
