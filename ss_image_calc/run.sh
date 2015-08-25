#!/bin/bash

set -x verbose
rm -rfv run

mkdir run
image_calc -o run/output.tif -d 6 -c "pow(var_0/3.0, 1.1)"  ../data/dem1_10pct.tif

