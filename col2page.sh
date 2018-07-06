#!/usr/bin/env bash

# col2page.sh
# -----------
#
# Save the forest: take a single column of text as input, and generate
# a multi-column text output, where columns are grouped to form pages.
#
# Optional arguments: [lipp [copp]]
#
#     lipp: number of lines per page
#           (default: should be 105, see ./src/col2page.ml)
#
#     copp: number of columns per page 
#           (default: should be 119 * lipp / 105, see ./src/col2page.ml)
#
# Example to quickly test it:
#
#     reset ; for i in {1..10000} ; do echo $i ; done | col2page.sh
#
# This way we can stuff as many columns on each page and save the forest :)
# (A bit) more seriously, col2page.sh's output is meant to be used by a2ps.
#
# Use at your own risk.
# The Boost license apply, as described in ./LICENSE
#
# Guillaume Lathoud, 2016
# glat@glat.info
#
# SEE ALSO:
#
#     ./col2page_ps.sh
#
#     UNIX commands `pr` and `paste`, which were not doing exactly
#     what I needed.

ocaml_compile_feedstdin_run.sh "$0" $@
