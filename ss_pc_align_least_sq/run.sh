#!/bin/bash

set -x verbose
rm -rfv run

# First run ICP to get an initial guess

pc_align ../data/ref_scale_dem.tif ../data/src_scale_dem.tif -o run/run --max-displacement 10000 --alignment-method similarity-point-to-point --max-num-reference-points 1000000000 --max-num-source-points 10000 --num-iterations 200 --save-transformed-source-points --save-inv-transformed-reference-points

# Then use that transform and refine it. Does not work that well though.

pc_align ../data/ref_scale_dem.tif ../data/src_scale_dem.tif -o run/run --max-displacement 10000 --alignment-method least-squares --max-num-reference-points 1000000000 --max-num-source-points 10000 --num-iterations 100 --save-transformed-source-points --save-inv-transformed-reference-points --initial-transform run/run-transform.txt



