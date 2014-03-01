#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/USGS_M_111_06_16_DEM_150cm_25pct.tif ../data/lola_lon_rad_lat.csv --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --max-num-source-points 5000000 --max-num-reference-points 1000000000 --max-displacement 100 --alignment-method point-to-plane --csv-format "4:lat 2:lon 3:radius_km"

