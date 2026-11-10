#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Bundle adjustment of a pinhole pair WITHOUT solving intrinsics (extrinsics
# only). Guards the no-float path: intrinsics must be held at their seed and
# passed through unchanged under the direct-value parametrization.
bundle_adjust ../data/left_sub16.tif ../data/right_sub16.tif \
  ../data/left_sub16.v2.tsai ../data/right_sub16.v2.tsai \
  -t pinhole --datum WGS84 --inline-adjustments \
  --num-iterations 5 --num-passes 1 --threads 1 -o run/run
