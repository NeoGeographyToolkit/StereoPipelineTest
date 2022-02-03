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

# Finally run bundle adjustment
bundle_adjust --solve-intrinsics ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.brownconrady.tsai ../data/right_sub16.brownconrady.tsai --inline-adjustments -t pinhole --datum WGS84 -o run/run --intrinsics-to-float other_intrinsics --disparity-list run/run-left_sub16__right_sub16-unaligned-D.tif --max-disp-error 10 --max-iterations 5 --parameter-tolerance 1e-12 --reference-terrain run/run-DEM.tif --max-num-reference-points 1000 --threads 1 --max-pairwise-matches 10000

