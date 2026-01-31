#!/bin/bash

set -x verbose
rm -rfv run

# Test the writing as uint8 and the --goc option
image_calc -c 'var_0' ../data/icebridge_b1.tif -d uint8 --cog -o run/run.tif

