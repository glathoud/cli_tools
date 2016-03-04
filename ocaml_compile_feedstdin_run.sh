#!/usr/bin/env bash

NATIVE=`echo $1 | sed s/\.[^\.]*$//`.native
ocamlbuild -quiet -I lib -I src $NATIVE
cat | $NATIVE ${@:2}
