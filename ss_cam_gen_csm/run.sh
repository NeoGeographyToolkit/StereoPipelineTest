#!/bin/bash

set -x verbose
rm -rfv run

# Convert a pinhole camera with radtan distortion to CSM exactly. Run cam_test to validate.

cam_gen ../data/1259344352.36984587_sc00104_c2_PAN_i0000000001.tif --input-camera ../data/skysat_radtan_dist.tsai -o run/run.json

cam_test --image ../data/1259344352.36984587_sc00104_c2_PAN_i0000000001.tif --cam1 ../data/skysat_radtan_dist.tsai --cam2 run/run.json > run/run.txt

