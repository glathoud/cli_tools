#!/usr/bin/env bash

set -e

BASE=${1%.*}
echo $BASE

TMP="/tmp/$(basename $BASE).ps"
echo $TMP

OUTPUT=$2
if [ ! "$OUTPUT" ]
then
    OUTPUT="${BASE}.pdf"
fi
echo $OUTPUT

a2ps -o "$TMP" "$1" ; ps2pdf "$TMP" "$OUTPUT"
