#!/usr/bin/env bash

convert "$1" -crop 100%x50%+0+0 "top_$1"
