#!/usr/bin/env bash

hocr2pdf ${@:4} -i "$1" -o "$3" < "$2"
