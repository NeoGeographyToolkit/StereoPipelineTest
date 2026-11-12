#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Float the optical bar velocity and motion-compensation factor from a zero seed.
# This is the KH-9 capability that additive intrinsics enable: a parameter seeded
# at 0 can be solved. The named optical-bar tokens float those sub-groups of the
# scan-motion vector while the rest is held fixed.
bundle_adjust                                                 \
  ../data/ghuffar_A021.tif ../data/ghuffar_F021.tif           \
  ../data/ghuffar_A021.tsai ../data/ghuffar_F021.tsai         \
  ../data/ghuffar_A021.gcp ../data/ghuffar_F021.gcp           \
  --inline-adjustments                                        \
  --solve-intrinsics                                          \
  --intrinsics-to-share none                                  \
  --intrinsics-to-float "velocity,motion_compensation_factor" \
  --num-iterations 100                                        \
  --num-passes 1                                              \
  --max-pairwise-matches 2000                                 \
  --remove-outliers-params "75 3 200 200"                     \
  --max-gcp-reproj-err 15                                     \
  --threads 1                                                 \
  -o run/run
