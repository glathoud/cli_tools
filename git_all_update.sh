#!/usr/bin/env sh

set -e

ME=$(realpath $0)
cd $(dirname $ME)/..

if [ -z "$1" ]
then
    find * -maxdepth 0 -type d -exec "$ME" "{}" \;
    exit 0
fi

D=$1
echo
echo "---------- $PWD/$D ----------"
A=$(ls -d $D/.git 2>>/dev/null)

if [ -z "$A" ]; then exit 0; fi

cd $D
git pull
git submodule update
