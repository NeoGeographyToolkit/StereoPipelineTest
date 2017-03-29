#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/ref_scale_dem.tif ../data/src_scale_dem.tif -o run/run --max-displacement 10000 --alignment-method similarity-point-to-point --max-num-reference-points 1000000000 --max-num-source-points 10000 --num-iterations 1000 --save-transformed-source-points --save-inv-transformed-reference-points 



