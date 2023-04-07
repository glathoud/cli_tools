#!/usr/bin/env sh

# inspired from https://unix.stackexchange.com/questions/729772/xrandr-change-saturation-less-color-more-black-white

xrandr --output "$1" --set CTM '1431655765,0,1431655765,0,1431655765,0,1431655765,0,1431655765,0,1431655765,0,1431655765,0,1431655765,0,1431655765,0'
