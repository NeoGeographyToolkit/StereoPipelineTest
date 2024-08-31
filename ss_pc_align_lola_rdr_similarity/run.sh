#!/bin/bash

set -x verbose
rm -rfv run

pc_align --csv-format 2:lat,3:lon,4:radius_km ../data/USGS_M_111_06_16_DEM_150cm_25pct.tif ../data/RDR_3E4E_24N27NPointPerRow_csv_table.csv --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --max-num-source-points 500000 --max-num-reference-points 1000000 --max-displacement 100 --alignment-method similarity-point-to-point

