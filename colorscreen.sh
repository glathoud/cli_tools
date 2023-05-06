#!/usr/bin/env sh

# inspired from https://unix.stackexchange.com/questions/729772/xrandr-change-saturation-less-color-more-black-white

if [ ! $1 ]; then
    echo "example parameter: HDMI-1  or  eDP-1"
    echo "...which we do right away, by default"
    "$0" "HDMI-1"
    "$0" "eDP-1"
    exit 0
fi

xrandr --output "$1" --set CTM '0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1'
