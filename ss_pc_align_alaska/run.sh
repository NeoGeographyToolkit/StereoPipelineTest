#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

pc_align $d/rock_dem_50pct.tif $d/lat_lon_z.csv --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --max-num-reference-points 1000000000 --max-displacement 100 





