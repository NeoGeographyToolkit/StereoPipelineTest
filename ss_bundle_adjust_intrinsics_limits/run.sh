#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Solve for the focal length with an absolute upper bound via
# --intrinsics-limits. The bound 2.79 is below where the unconstrained solve
# lands (about 2.80), so the focal clamps exactly to 2.79. This verifies that
# --intrinsics-limits bounds the absolute parameter value, not a ratio of the
# initial value (a ratio of 2.79 would give a focal near 7.8).
bundle_adjust ../data/left_sub16.tif ../data/right_sub16.tif \
  ../data/left_sub16.v2.tsai ../data/right_sub16.v2.tsai \
  -t pinhole --datum WGS84 --inline-adjustments --solve-intrinsics \
  --intrinsics-to-float focal_length --intrinsics-limits "2.75 2.79" \
  --num-iterations 10 --num-passes 1 --threads 1 -o run/run
