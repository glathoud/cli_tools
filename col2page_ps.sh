#!/usr/bin/env bash

# col2page_ps.sh
# --------------
#
# Wrap a text into columns, producing pages in PS format.
# Based on ./col2page.sh
#
# Example to quickly test it:
#
#     for i in {1..10000} ; do echo $i ; done | col2page_ps.sh test.ps
#     evince test.ps
#
# Use at your own risk.
# The Boost license apply, as described in ./LICENSE
# 
# Guillaume Lathoud, 2016
# glat@glat.info
#
# SEE ALSO:
#
#     ./col2page.sh
#
#     UNIX commands `pr` and `paste`, which were not doing exactly
#     what I needed.

# mandatory
OUTPUT_FILE=$1   

# optional
LIPP=${2:-105} 
COPP=$3

./col2page.sh ${LIPP} ${COPP} | a2ps -L ${LIPP} -R -B --rows=1 --columns=1 -o ${OUTPUT_FILE}

