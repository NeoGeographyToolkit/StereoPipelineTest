#!/bin/bash

set -x verbose
rm -rfv run

# Run bundle_adjust with a terrain constraint

# First get the unaligned disparity and the interest points
stereo ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.brownconrady.tsai ../data/right_sub16.brownconrady.tsai --num-matches-from-disp-triplets 10000 --unalign-disparity run/run

# Create the reference terrain
point2dem run/run-PC.tif

# Copy the match file to the new name
mv -fv run/run-disp-left_sub16__right_sub16.match run/run-left_sub16__right_sub16.match

bundle_adjust --solve-intrinsics ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.brownconrady.tsai ../data/right_sub16.brownconrady.tsai --inline-adjustments -t pinhole --datum WGS84 -o run/run --intrinsics-to-float other_intrinsics --parameter-tolerance 1e-12 --heights-from-dem run/run-DEM.tif --max-num-reference-points 1000 --threads 1 --num-passes 1 --num-iterations 4 --mapproj-dem run/run-DEM.tif --heights-from-dem-uncertainty 10

