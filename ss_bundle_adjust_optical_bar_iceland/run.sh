#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Bundle adjustment of a KH-9 panoramic optical-bar pair in VELOCITY-VECTOR
# (Ghuffar) mode. The cameras carry a velocity line, which selects the
# velocity-mode path, so --intrinsics-to-float other_intrinsics floats the
# scan-motion model (velocity, motion compensation, final pose) from the cam_gen
# zero seed, with focal length and optical center held fixed. This exercises the
# velocity-mode path that the legacy ss_bundle_adjust_optical_bar test does not.
# Left = aft (A021), right = fore (F021). Corner GCPs plus heights-from-dem give
# the ground constraint. The sub16 Iceland frames keep it fast (a few seconds).
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
  --intrinsics-to-float other_intrinsics             \
  --heights-from-dem ../data/IL_reference_dem_large.tif \
  --heights-from-dem-uncertainty 200                 \
  --num-iterations 100                               \
  --num-passes 2                                     \
  --max-pairwise-matches 2000                        \
  --remove-outliers-params "75 3 200 200"            \
  --max-gcp-reproj-err 15                            \
  --threads 1                                        \
  --ip-per-image 2000                                \
  -o run/run
