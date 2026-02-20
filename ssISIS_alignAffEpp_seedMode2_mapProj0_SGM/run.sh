#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo                            \
  --matches-as-txt                         \
  ../data/M0100115_crop.cub                \
  ../data/E0201461.cub                     \
  run/run                                  \
  -s stereo.default                        \
  --disable-fill-holes                     \
  --left-image-crop-win  145 1591 250 280  \
  --right-image-crop-win  90 976 510 650   \
  --disparity-estimation-dem               \
  ../data/seed-mode-2-init-DEM.tif         \
  --disparity-estimation-dem-error 5       \
  --alignment-method affineepipolar        \
  --corr-seed-mode 2                       \
  --stereo-algorithm asp_mgm               \
  --corr-tile-size 2000                    \
  --cost-mode 4                            \
  --corr-kernel 9 9
point2dem                                  \
  -r mars run/run-PC.tif                   \
  --nodata-value                           \
  -32767

# Test the disparitydebug --raw option
disparitydebug --raw run/run-F.tif

