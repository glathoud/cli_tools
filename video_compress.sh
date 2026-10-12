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

# output in the current directory
HEAD=$(basename "${IN_FN%.*}")
#OUT_TAIL="${IN_FN##*.}"  # keep format
OUT_TAIL="mp4"  # convert to MP4

CRF="28"

if [[ ! -f "$IN_FN" ]]
then
    echo "$ME: could not find IN_FN: \"$IN_FN\""
    exit 1
fi

opt=( -c:v libx265 -crf "${CRF}" -preset slow -c:a copy -tag:v hvc1 )  # hvc1: for iPhones
if [[ "$2" == "-half" ]]
then
    opt=(  -vf "scale=trunc(iw/4)*2:trunc(ih/4)*2"  "${opt[@]}" )
    HEAD="${HEAD}_half"
fi

OUT_HEAD="${HEAD}_x265_crf${CRF}"

OUT_FN="${OUT_HEAD}.${OUT_TAIL}"

if [[ -f "$OUT_FN" ]]
then
    echo "$ME: output already exists: OUT_FN:\"$OUT_FN\""
    exit 2
else
    ffmpeg -i "$IN_FN" "${opt[@]}" "$OUT_FN"
fi
