#!/usr/bin/env bash

# Example of use:
# rm *.mp3 ; reset ; find . -iname '*.mp4' -print0 | parallel -0 -q a.sh {}

INPUT=$1
OUTPUT=$(echo $INPUT | sed -r 's/\.[^\.]+$/.mp3/')

ffmpeg -i "$INPUT" -vn \
       -acodec libmp3lame -ac 2 -qscale:a 4 -ar 48000 \
        "$OUTPUT"
