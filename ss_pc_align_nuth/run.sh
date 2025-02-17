#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/rock_dem_50pct_crop1.tif ../data/rock_dem_50pct_shift_10_20_30.tif -o run/run --max-displacement 5002 --compute-translation-only --threads 1 --alignment-method nuth --nuth-options "--slope-lim 0.1025 40.4 --tol 0.0013 --num-inner-iter 12 --max-vertical-offset 6005 --max-horizontal-offset 6066"

