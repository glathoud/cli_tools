#!/usr/bin/env bash

# Tar many subdirectories at a given depth
# Use at your own risk.
#
# By Guillaume Lathoud, 2023
# The Boost License applies, see file ./LICENSE

set -e # stop at first error

CONTDEPTH="$1"
if [[ ! "$CONTDEPTH" ]]; then
    CONTDEPTH=3
fi

WHERE="$2"
if [[ ! "$WHERE" ]]; then
    WHERE="$PWD"
fi

echo "CONTDEPTH: $CONTDEPTH"
echo "WHERE:     $WHERE"

cd "$WHERE"

gg(){
    TAR_FN="$1.tar.gz"
    echo "CONT: $PWD  ;;  DIR: $1  =>  TAR_FN: $TAR_FN"
    if [[ "$1" != "."  &&  "$1" != ".."  &&  ! -L "$1" ]]; then
        tar zcf "$TAR_FN" "$1" && rm -rf "$1"
    fi
}
export -f gg

ff(){
    if [[ "$1" != "."  &&  "$1" != ".."  &&  ! -L "$1"  ]]; then
        cd "$1"
        find . -mindepth 1 -maxdepth 1 -type d | parallel -n 1 -j 1 gg
        cd - >/dev/null
    fi
}
export -f ff

find . -mindepth "$CONTDEPTH" -maxdepth "$CONTDEPTH" -type d | parallel -n 1 ff

cd - >/dev/null
