#!/usr/bin/env bash

# Convert RAW (e.g. Cannon) images to JPG
# Guillaume Lathoud, 2023 - glat@glat.info
# The Boost License applies, see ./LICENSE

IN_CRW="$1"
OUT_PPM="${IN_CRW%.*}.ppm"
OUT_JPG="${IN_CRW%.*}.jpg"
dcraw -w "$IN_CRW"
convert -quality 100 "$OUT_PPM" "$OUT_JPG"
exiftran -a -i "$OUT_JPG"
exiftool -tagsfromfile "$IN_CRW" "$OUT_JPG"
exiftool -Orientation=Horizontal "$OUT_JPG"
rm "$OUT_PPM" "${OUT_JPG}_original" 2>>/dev/null
