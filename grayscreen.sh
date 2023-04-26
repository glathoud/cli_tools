#!/usr/bin/env sh

# inspired from https://unix.stackexchange.com/questions/729772/xrandr-change-saturation-less-color-more-black-white

if [ ! $1 ]; then
    echo "example parameter: HDMI-1  or  eDP-1"
    exit 1
fi

xrandr --output "$1" --set CTM '1431655765,0,1431655765,0,1431655765,0,1431655765,0,1431655765,0,1431655765,0,1431655765,0,1431655765,0,1431655765,0'
