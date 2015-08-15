#!/bin/bash

set -x verbose
rm -rfv run

pc_align --max-displacement 100 ../data/ref-mars-PC-crop.tif ../data/ref-mars-PC_trans-crop.tif  --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run  --max-num-reference-points 1000000 --max-num-source-points 10000

