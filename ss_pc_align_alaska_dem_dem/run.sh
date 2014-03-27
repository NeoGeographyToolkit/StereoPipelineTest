#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/rock_dem_50pct_crop1.tif ../data/rock_dem_50pct_crop2.tif --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --max-num-reference-points 1000000000 --max-displacement 1000


