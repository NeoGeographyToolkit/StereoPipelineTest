#!/bin/bash

set -x verbose
rm -rfv run

echo ../data/left_sub16.tif ../data/right_sub16.tif > list.txt
bundle_adjust --solve-intrinsics ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.null.tsai ../data/right_sub16.null.tsai ../data/gcp_sub16.gcp --inline-adjustments -t pinhole --datum WGS84 -o run/run --intrinsics-to-float "focal_length other_intrinsics" --overlap-list list.txt --threads 1

