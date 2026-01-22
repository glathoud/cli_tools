#!/usr/bin/env bash

BC="$1"
IN_FILE="$2"
OUT_FILE="$3"
[[ "" == "$OUT_FILE" ]]  &&  {
    TMP="${BC/,/_}"
    TMP="${TMP/+/p}"
    TMP="${TMP/-/m}"
    OUT_FILE="${IN_FILE%.*}__bc_${TMP}.${IN_FILE##*.}"
}

([[ "" == "$BC" ]]  ||  [[ "" == "$IN_FILE" ]]  ||  [[ "" == "$OUT_FILE" ]])  &&  {
    echo "Example usage: $(basename $0) 0,+10  input_file.pdf  output_file.pdf"
    echo "Example usage: $(basename $0) 0,+10  input_file.jpg  output_file.jpg"
    echo "Example usage: $(basename $0) 0,+10  input_file.pdf  # (use default output filename)"
    echo "Example usage: $(basename $0) 0,+10  input_file.jpg  # (use default output filename)"
    exit 1
}

CMD=(convert -density 300 "$IN_FILE" -brightness-contrast "$BC" "$OUT_FILE")
echo "${CMD[@]}"

"${CMD[@]}"
