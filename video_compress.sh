#!/usr/bin/bash

# Video compression tool
#
# Based on
# https://unix.stackexchange.com/questions/28803/how-can-i-reduce-a-videos-size-with-ffmpeg
#
# Examples:
#
# video_compress.sh input_file.mp4
# video_compress.sh input_file.mp4 -half
#
# Both create a new file, which should be smaller than the original.
# 
# Guillaume Lathoud, 2022
# The Boost License apply, see file ./LICENSE

set -e

ME="$(basename $0)"

IN_FN="$1"
HEAD="${IN_FN%.*}"
TAIL="${IN_FN##*.}"

CRF="28"

if [[ ! -f "$IN_FN" ]]
then
    echo "$ME: could not find IN_FN: \"$IN_FN\""
    exit 1
fi

opt=( -vcodec libx265 -crf "$CRF" )
if [[ "$2" == "-half" ]]
then
    opt=(  -vf "scale=trunc(iw/4)*2:trunc(ih/4)*2"  "${opt[@]}" )
    HEAD="${HEAD}_half"
fi

HEAD="${HEAD}_x265_crf${CRF}"

OUT_FN="${HEAD}.${TAIL}"

if [[ -f "$OUT_FN" ]]
then
    echo "$ME: output already exists: OUT_FN:\"$OUT_FN\""
    exit 2
else
    ffmpeg -i" $IN_FN" "${opt[@]}" "$OUT_FN"
fi
