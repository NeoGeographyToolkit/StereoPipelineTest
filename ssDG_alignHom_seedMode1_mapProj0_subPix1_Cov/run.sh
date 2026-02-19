#!/bin/bash

set -x verbose
rm -rfv run

img1=../data/grand_mesa_WV03_left_crop.tif
img2=../data/grand_mesa_WV03_right_crop.tif
cam1=../data/grand_mesa_WV03_left.xml
cam2=../data/grand_mesa_WV03_right.xml

parallel_stereo                                    \
  $img1 $img2                                      \
  $cam1 $cam2                                      \
  run/run                                          \
  --bundle-adjust-prefix ../data/ba_grand_mesa/run \
  --alignment-method affineepipolar                \
  --stereo-algorithm asp_mgm                       \
  --subpixel-mode 9                                \
  -t dg                                            \
  --propagate-errors                               \
  --left-image-crop-win 17664 5325 435 500         \
  --right-image-crop-win 5279 15622 414 500        \
  --corr-tile-size 5000

point2dem --propagate-errors run/run-PC.tif
