#!/bin/bash

set -x verbose
rm -rfv run

pc_align --csv-format 1:lat,2:lon,3:height_above_datum --max-displacement 300 ../data/ref-mars-PC.tif ../data/ref-mars.csv  --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --datum mola --max-num-reference-points 10000000


