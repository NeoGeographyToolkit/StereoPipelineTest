#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/Severnaya-Bedrock-UTM47-Ellipsoidal-Height.txt ../data/Severnaya-Bedrock-UTM47-Ellipsoidal-Height.txt --csv-format "1:easting 2:northing 3:height_above_datum" --csv-srs '+proj=utm +zone=47 +datum=WGS84 +units=m +no_defs' --max-displacement 100 --save-transformed-source-points --save-inv-transformed-reference-points --max-num-reference-points 1000000 --max-num-source-points 100000 --alignment-method point-to-point -o run/run

