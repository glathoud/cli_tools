#!/usr/bin/env sh

find . -maxdepth 1 -name '*.tar.gz' -exec tar zxf {} \; -exec rm {} \;
