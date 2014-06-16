#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/rock_dem_50pct.tif ../data/lat_lon_z.csv --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --max-num-reference-points 1000000 --max-num-source-points 5000  --max-displacement 100 

