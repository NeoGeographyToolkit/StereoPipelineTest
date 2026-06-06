#!/bin/bash

# HRSC testcase.
# https://stereopipeline.readthedocs.io/en/latest/examples/hrsc.html

set -x verbose
rm -rfv run

# The clips are grown and interest point matching is relaxed (more points
# per tile, higher uniqueness threshold) so enough matches are found for
# epipolar alignment on these stereo channels.
parallel_stereo                            \
  --left-image-crop-win 200 1100 850 850   \
  --right-image-crop-win 290 1330 780 720  \
  --stereo-algorithm asp_mgm               \
  --min-num-ip 5                           \
  --ip-per-tile 2000                       \
  --ip-uniqueness-threshold 0.9            \
  ../data/HD755_0000_S12_crop.cub          \
  ../data/HD755_0000_S22_crop.cub          \
  run/run

point2dem --stereographic --auto-proj-center run/run-PC.tif
