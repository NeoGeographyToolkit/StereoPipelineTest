#!/bin/bash

set -x verbose
rm -rfv run

echo "1.2  0    0    2000"  > transform.txt
echo "0    1.2  0    3000" >> transform.txt
echo "0    0    1.2  4000" >> transform.txt
echo "0    0    0       1" >> transform.txt

# First do bundle adjustment
bundle_adjust --solve-intrinsics ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.v2.tsai ../data/right_sub16.v2.tsai ../data/gcp_sub16.gcp --inline-adjustments -t pinhole --datum WGS84 -o run/ba1/run --intrinsics-to-float "other_intrinsics" --threads 1

# Then just apply a transform
bundle_adjust ../data/left_sub16.tif ../data/right_sub16.tif  run/ba1/run-left_sub16.v2.tsai run/ba1/run-right_sub16.v2.tsai --inline-adjustments -t pinhole --datum WGS84 -o run/run --initial-transform transform.txt --apply-initial-transform-only --threads 1

