#!/bin/bash

# Test stereo_dist with --mapproject using RPC images.

set -x verbose
rm -rfv run

dem="../data/img_01__img_02_rpc_dem.tif"
img1="../data/img_01_crop.tif"
img2="../data/img_02.tif"

pdopt='--tr 0.75 --orthoimage --errorimage'

stereo_dist                      \
  --mapproject                   \
  --dem $dem                     \
  $img1 $img2                    \
  run/run                        \
  --alignment-method none        \
  --corr-seed-mode 1             \
  --subpixel-mode 9              \
  --stereo-algorithm asp_mgm     \
  --tile-size 2048               \
  --tile-padding 128             \
  --point2dem-options "$pdopt"
