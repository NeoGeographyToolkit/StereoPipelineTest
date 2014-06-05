#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/rock_dem_50pct.tif ../data/z_lat_lon.csv --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --max-num-reference-points 10000000 --max-num-source-points 10000 --max-displacement 100 --csv-format "1:height_above_datum 3:lon 2:lat"





