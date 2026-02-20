#!/bin/bash

# Test stereo_dist with --mapproject flag.
# Uses ISIS .cub files with embedded cameras.

set -x verbose
rm -rfv run

dem="../data/dem_clip_M0100115_E0201461.tif"
img1="../data/M0100115.cub"
img2="../data/E0201461.cub"

stereo_dist                      \
  --mapproject                   \
  --dem $dem                     \
  $img1 $img2                    \
  run/run                        \
  --alignment-method none        \
  --corr-seed-mode 1             \
  --subpixel-mode 1              \
  --tile-size 600                \
  --tile-padding 128             \
  --point2dem-options '--tr 4'   \
  --t_projwin 482 -5155 1110 -4545
