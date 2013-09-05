#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

pc_align $d/USGS_M_111_06_16_DEM_150cm_25pct.tif $d/RDR_3E4E_24N27NPointPerRow_csv_table.csv --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --max-num-source-points 5000000 --max-num-reference-points 1000000000 --max-displacement 100 --alignment-method point-to-plane





