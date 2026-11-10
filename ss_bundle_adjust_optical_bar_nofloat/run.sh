#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Bundle adjustment of an optical bar pair WITHOUT solving intrinsics. The
# optical bar motion state (focal length, speed, motion compensation) must be
# held at the seed and passed through unchanged. Only the extrinsics move.
bundle_adjust ../data/DS1105-2248DA079.tif ../data/DS1105-2248DA079_crop.tif \
  ../data/DS1105-2248DA079.tsai ../data/DS1105-2248DA079_crop.tsai \
  --num-iterations 3 --num-passes 1 --inline-adjustments \
  --max-pairwise-matches 100 --threads 1 --ip-per-image 100 \
  -o run/run
