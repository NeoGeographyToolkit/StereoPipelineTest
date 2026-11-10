#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Bundle adjustment of a KH-9 panoramic optical-bar pair in VELOCITY-VECTOR
# (Ghuffar) mode. The cameras carry a velocity line, which selects the
# velocity-mode path. --intrinsics-to-float names a motion parameter directly
# (here final_pose), floating only that part of the scan-motion model from the
# cam_gen seed, with the rest of the intrinsics held fixed. This exercises both
# the velocity-mode path and the per-parameter float controls that the legacy
# ss_bundle_adjust_optical_bar test does not. Left = aft (A021), right = fore
# (F021). Corner GCPs plus heights-from-dem give the ground constraint. The
# sub16 Iceland frames keep it fast (a few seconds).
# One pass only. This small pair has high reprojection residuals, so a second
# pass with outlier removal would cull most points and leave too few. One pass
# is deterministic.
bundle_adjust                                        \
  ../data/D3C1216-200533A021_crop_sub16.tif          \
  ../data/D3C1216-200533F021_crop_sub16.tif          \
  ../data/D3C1216-200533A021_crop_sub16.tsai         \
  ../data/D3C1216-200533F021_crop_sub16.tsai         \
  ../data/D3C1216-200533A021_crop_sub16.gcp          \
  ../data/D3C1216-200533F021_crop_sub16.gcp          \
  --inline-adjustments                               \
  --solve-intrinsics                                 \
  --intrinsics-to-share none                         \
  --intrinsics-to-float final_pose                   \
  --heights-from-dem ../data/IL_reference_dem_large.tif \
  --heights-from-dem-uncertainty 200                 \
  --num-iterations 100                               \
  --num-passes 1                                     \
  --max-pairwise-matches 2000                        \
  --max-gcp-reproj-err 15                            \
  --threads 1                                        \
  --ip-per-image 2000                                \
  -o run/run
