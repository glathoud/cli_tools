#!/usr/bin/env bash

convert "$1" -crop 50%x100%+0+0 "left_$1"
