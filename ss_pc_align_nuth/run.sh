#!/bin/bash

set -x verbose
rm -rfv run

nuth --ref ../data/rock_dem_50pct_crop1.tif --src ../data/rock_dem_50pct_shift_10_20_30.tif -o run/run --tol 0.011 --max-offset 5002 --max-dz 5004 --max-iter 43 --res mean --slope-lim 0.12 41.3 --poly-order 1 --threads 1 --compute-translation-only

