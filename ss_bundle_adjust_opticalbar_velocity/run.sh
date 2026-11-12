#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Float the optical bar velocity and motion-compensation factor from a zero seed.
# This is the KH-9 capability that additive intrinsics enable: a parameter seeded
# at 0 can now be solved. The other_intrinsics blob is
#   [speed, MCF, scan_time, velocity(3), final_pose(3)]
# so fixing indices 0 2 6 7 8 floats only MCF (1) and velocity (3,4,5).
bundle_adjust                                           \
  ../data/ghuffar_A021.tif ../data/ghuffar_F021.tif     \
  ../data/ghuffar_A021.tsai ../data/ghuffar_F021.tsai   \
  ../data/ghuffar_A021.gcp ../data/ghuffar_F021.gcp      \
  --inline-adjustments                                  \
  --solve-intrinsics                                    \
  --intrinsics-to-share none                            \
  --intrinsics-to-float other_intrinsics                \
  --fixed-distortion-indices "0 2 6 7 8"                \
  --num-iterations 100                                  \
  --num-passes 1                                        \
  --max-pairwise-matches 2000                           \
  --remove-outliers-params "75 3 200 200"               \
  --max-gcp-reproj-err 15                               \
  --threads 1                                           \
  -o run/run
