#!/bin/bash

# HRSC testcase.
# https://stereopipeline.readthedocs.io/en/latest/examples/hrsc.html

set -x verbose
rm -rfv run

parallel_stereo                            \
  --left-image-crop-win 339 1297 725 694   \
  --right-image-crop-win 432 1531 652 545  \
  --stereo-algorithm asp_mgm               \
  --min-num-ip 5                           \
  ../data/HD755_0000_S12_crop.cub          \
  ../data/HD755_0000_S22_crop.cub          \
  run/run

point2dem --stereographic --auto-proj-center run/run-PC.tif
