#!/bin/bash

set -x verbose
rm -rfv run

image_calc -c 'var_0' ../data/icebridge_b1.tif -d uint8 -o run/run.tif

