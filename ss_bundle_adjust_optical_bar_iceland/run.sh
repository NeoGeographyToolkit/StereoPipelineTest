#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# KH-9 optical-bar velocity-mode (Ghuffar) pair. Derive left-scan cameras from
# the right-scan data (flip scan_dir, set a nonzero MCF) to exercise velocity-mode
# left scan. Float the velocity (shared across both cameras) and final_pose (per
# camera) by name, holding the motion compensation factor. One pass, for
# determinism. The two solved cameras must carry the same velocity (validate.sh).
for f in D3C1216-200533A021_crop_sub16 D3C1216-200533F021_crop_sub16; do
  perl -pe 's/^scan_dir = right$/scan_dir = left/; s/^motion_compensation_factor = 0$/motion_compensation_factor = 0.05/' \
    ../data/$f.tsai > run/$f.tsai
done

bundle_adjust                                           \
  ../data/D3C1216-200533A021_crop_sub16.tif             \
  ../data/D3C1216-200533F021_crop_sub16.tif             \
  run/D3C1216-200533A021_crop_sub16.tsai                \
  run/D3C1216-200533F021_crop_sub16.tsai                \
  ../data/D3C1216-200533A021_crop_sub16.gcp             \
  ../data/D3C1216-200533F021_crop_sub16.gcp             \
  --inline-adjustments                                  \
  --solve-intrinsics                                    \
  --intrinsics-to-share velocity                        \
  --intrinsics-to-float "velocity final_pose"           \
  --heights-from-dem ../data/IL_reference_dem_large.tif \
  --heights-from-dem-uncertainty 200                    \
  --num-iterations 100                                  \
  --num-passes 1                                        \
  --max-pairwise-matches 2000                           \
  --max-gcp-reproj-err 15                               \
  --threads 1                                           \
  --ip-per-image 2000                                   \
  -o run/run
