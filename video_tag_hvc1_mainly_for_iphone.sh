#!/usr/bin/bash

set -e

ME="$(basename $0)"

IN_FN="$1"

# output in the current directory
HEAD=$(basename "${IN_FN%.*}")
#OUT_TAIL="${IN_FN##*.}"  # keep format
OUT_TAIL="mp4"  # convert to MP4

OUT_HEAD="${HEAD}__hvc1"
OUT_FN="${OUT_HEAD}.${OUT_TAIL}"

ffmpeg -i "${IN_FN}" -c copy -tag:v hvc1 "${OUT_FN}"
