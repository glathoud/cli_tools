#!/usr/bin/bash

# Video horizontal flip tool + h265 compression
#
# video_hflip.sh input_file.mp4
# video_hflip.sh input_file.mp4 -half # also divide size by two
#
# Both create a new file containing the horizontally flipped,
# compressed video.
#
# TODO: merge with video_compress.sh , moving to generic option management
# 
# Guillaume Lathoud, 2026
# The Boost License apply, see file ./LICENSE

set -e

ME="$(basename $0)"

IN_FN="$1"

# output in the current directory
HEAD=$(basename "${IN_FN%.*}")
#OUT_TAIL="${IN_FN##*.}"  # keep format
OUT_TAIL="mp4"  # convert to MP4

#CRF="17" # minimal loss => yeah but leads to gigantic files
CRF="28"  # so let us compress right away like ./video_compress.sh does

if [[ ! -f "$IN_FN" ]]
then
    echo "$ME: could not find IN_FN: \"$IN_FN\""
    exit 1
fi

opt=( -vf "hflip" -c:v libx265 -crf "${CRF}" -preset slow -c:a copy -tag:v hvc1 )  # hvc1: for iPhones
if [[ "$2" == "-half" ]]
then
    opt=(  -vf "scale=trunc(iw/4)*2:trunc(ih/4)*2"  "${opt[@]}" )
    HEAD="${HEAD}_half"
fi

OUT_HEAD="${HEAD}_hflip_x265_crf${CRF}"

OUT_FN="${OUT_HEAD}.${OUT_TAIL}"

if [[ -f "$OUT_FN" ]]
then
    echo "$ME: output already exists: OUT_FN:\"$OUT_FN\""
    exit 2
else
    ffmpeg -i "$IN_FN" "${opt[@]}" "$OUT_FN"
fi
