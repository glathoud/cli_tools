#!/usr/bin/env sh

FILENAME="$1"
if [ -f "$FILENAME" ]
then
    set -e
    cat "$FILENAME" | sed 's/},{/}!{/g' | tr '!' "\n" | less
else
    echo "File not found: $FILENAME" >&2
    exit 1
fi
