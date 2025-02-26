#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Test --overlap-list
echo ../data/left_sub16.tif ../data/right_sub16.tif > run/list.txt
bundle_adjust --solve-intrinsics ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.null.tsai ../data/right_sub16.null.tsai ../data/gcp_sub16.gcp --inline-adjustments -t pinhole --datum WGS84 -o run/run --intrinsics-to-float "focal_length other_intrinsics" --overlap-list run/list.txt --threads 1 --num-iterations 50

# Test writing an isis cnet
bundle_adjust --threads 1 ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.null.tsai ../data/right_sub16.null.tsai -t pinhole --datum WGS84 --output-cnet-type isis-cnet --match-files-prefix run/run -o run/run-cnet

# Test reading it back
bundle_adjust --threads 1 ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.null.tsai ../data/right_sub16.null.tsai -t pinhole --datum WGS84 -o run/run-v2 --output-cnet-type match-files --isis-cnet run/run-cnet.net

