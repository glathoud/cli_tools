#!/usr/bin/env bash

m="$1"

v=$(od -An -N4 -tu4 /dev/urandom  | sed -E 's/^\s+|\s+$//g')

if [ -n "$m" ]; then
    v=$(( "$v" % "$m" ))
fi

echo "$v"
