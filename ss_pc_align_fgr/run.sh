#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/rock_dem_50pct.tif ../data/lat_lon_z.csv --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --max-num-reference-points 50000 --max-num-source-points 3000  --max-displacement 50  --initial-ned-translation '-1 -1 -2' --alignment-method fgr

