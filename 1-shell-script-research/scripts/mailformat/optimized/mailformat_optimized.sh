#!/bin/bash

ARGS=1
E_BADARGS=85
E_NOFILE=86
MAXWIDTH=70

if [ $# -ne 1 ]; then
    echo "Usage: $(basename "$0") filename"
    exit $E_BADARGS
fi

if [ ! -f "$1" ]; then
    echo "File \"$1\" does not exist."
    exit $E_NOFILE
fi

sed '
s/^>//
s/^ *>//
s/^ *//
s/ *//
' "$1" | fold -s -w "$MAXWIDTH"

exit 0
