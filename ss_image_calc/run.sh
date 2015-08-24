#!/bin/bash

set -x verbose
rm -rfv run

mkdir run
image_calc -o run/output.tif -d 6 -c "(var_0 + var_1)/2.0"  ../data/dem1_10pct.tif ../data/dem2_10pct.tif

