#!/bin/bash

# Optimized Random Password Generator
# Generates secure random alphanumeric passwords efficiently

MATRIX="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
LENGTH="${1:-8}"
CHARSET_SIZE=${#MATRIX}

PASS=""

for ((i=0; i<LENGTH; i++)); do
    PASS+="${MATRIX:RANDOM%CHARSET_SIZE:1}"
done

echo "$PASS"
exit 0
