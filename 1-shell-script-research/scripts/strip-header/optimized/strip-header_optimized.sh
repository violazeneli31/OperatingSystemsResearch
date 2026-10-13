#!/bin/bash

# Optimized Strip Header Script
# Removes mail/News headers efficiently

strip_header() {
    sed -e '1,/^$/d' -e '/^[[:space:]]*$/d'
}

if (( $# == 0 )); then
    strip_header
else
    for file; do
        [[ -r "$file" ]] || continue
        strip_header < "$file"
    done
fi

exit 0
