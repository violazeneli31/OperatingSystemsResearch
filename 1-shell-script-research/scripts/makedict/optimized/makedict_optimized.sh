#!/bin/bash

# Optimized Makedict Script
# Efficiently processes text files to produce sorted unique words

[[ ! -r "$1" ]] && {
    echo "Usage: $0 files-to-process"
    exit 85
}

cat "$@" |
    tr '[:upper:]' '[:lower:]' |
    tr -cs '[:lower:]' '\n' |
    sort -u |
    grep -v '^$'

exit $?
