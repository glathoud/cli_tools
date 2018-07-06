#!/usr/bin/env bash

gunzip -c -S .gz $1 | od -Ad -t x1
