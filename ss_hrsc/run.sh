#!/bin/bash

# HRSC testcase.
# https://stereopipeline.readthedocs.io/en/latest/examples/hrsc.html

set -x verbose
rm -rfv run
mkdir -p run

# Sanity-check: verify the pre-made CSM JSONs (generated from full uncropped
# cubes) agree with the ISIS camera on the cropped cubes. The ISDs were made
# offline because isd_generate on cropped HRSC cubes produces broken timing
# tables (ALE bug). This cam_test catches any future drift between ISIS and CSM.
cam_test --image ../data/HD755_0000_S12_crop.cub  \
  --cam1 ../data/HD755_0000_S12_crop.cub          \
  --cam2 ../data/HD755_0000_S12.json              \
  --session1 isis --session2 csm                  \
  --sample-rate 100 > run/cam_test_s12.txt 2>&1

cam_test --image ../data/HD755_0000_S22_crop.cub  \
  --cam1 ../data/HD755_0000_S22_crop.cub          \
  --cam2 ../data/HD755_0000_S22.json              \
  --session1 isis --session2 csm                  \
  --sample-rate 100 > run/cam_test_s22.txt 2>&1

# The clips are grown and interest point matching is relaxed (more points
# per tile, higher uniqueness threshold) so enough matches are found for
# epipolar alignment on these stereo channels. The clips are a bit wider
# than strictly needed so the small set of matches surviving the
# triangulation filter on these low-texture channels is enough for the
# epipolar fit on all platforms (including linux-aarch64).
parallel_stereo                            \
  --left-image-crop-win 200 1000 850 950   \
  --right-image-crop-win 290 1230 800 870  \
  --stereo-algorithm asp_mgm               \
  --min-matches 5                          \
  --ip-per-tile 2000                       \
  --ip-uniqueness-threshold 0.9            \
  ../data/HD755_0000_S12_crop.cub          \
  ../data/HD755_0000_S22_crop.cub          \
  run/run

point2dem --stereographic --auto-proj-center run/run-PC.tif
