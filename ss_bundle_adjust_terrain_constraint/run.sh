#!/bin/bash

set -x verbose
rm -rfv run

# Run bundle_adjust with a terrain constraint

# First get the unaligned disparity and the interest points
stereo ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.brownconrady.tsai ../data/right_sub16.brownconrady.tsai --num-matches-from-disp-triplets 3000 --unalign-disparity run/run

# Create the reference terrain
point2dem run/run-PC.tif

# Finally run bundle adjustment. A tight --max-disp-error is used on purpose: the
# reference-terrain point selection uses the current cameras (base + ba_state) each
# pass, and only a tight gate is sensitive to the per-pass camera update on these
# long-range cameras (a large camera move is a tiny projection shift). With a loose
# gate the result is the same with or without that fix.
bundle_adjust --solve-intrinsics ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.brownconrady.tsai ../data/right_sub16.brownconrady.tsai --inline-adjustments -t pinhole --datum WGS84 -o run/run --intrinsics-to-float other_intrinsics --disparity-list run/run-unaligned-D.tif --max-disp-error 0.5 --max-iterations 5 --parameter-tolerance 1e-12 --reference-terrain run/run-DEM.tif --max-num-reference-points 300 --threads 1 --max-pairwise-matches 3000 --match-files-prefix run/run-disp

