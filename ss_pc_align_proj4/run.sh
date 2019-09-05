#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/13APR25_WV02_SEVZ_1030010021A8A100_10030010021A64500_DEM3-3m_10pct.tif ../data/Severnaya-Bedrock-UTM47-Ellipsoidal-Height.txt --csv-format "1:easting 2:northing 3:height_above_datum" --csv-proj4 '+proj=utm +zone=47 +datum=WGS84 +units=m +no_defs' --max-displacement 100 --save-transformed-source-points --save-inv-transformed-reference-points --max-num-reference-points 1000000 --max-num-source-points 100000
#Severnaya_UTM47_llh.txt

