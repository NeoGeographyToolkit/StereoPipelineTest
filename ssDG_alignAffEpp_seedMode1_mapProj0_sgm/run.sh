#!/bin/bash

set -x verbose
rm -rfv run

img1=../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.tif
img2=../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.tif
cam1=../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.xml
cam2=../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.xml

parallel_stereo                           \
  $img1 $img2                             \
  $cam1 $cam2                             \
  run/run                                 \
  --disable-fill-holes                    \
  --stereo-file stereo.default            \
  --left-image-crop-win 1851 801 341 323  \
  --right-image-crop-win 1870 643 451 433 \
  -t dg                                   \
  --alignment-method affineepipolar       \
  --corr-seed-mode 1                      \
  --subpixel-mode 0                       \
  --stereo-algorithm asp_sgm              \
  --corr-kernel 7 7                       \
  --xcorr-threshold 2.5                   \
  --corr-max-levels 4                     \
  --cost-mode 4                           \
  --min-num-ip 5                          \
  --save-left-right-disparity-difference  \
  --job-size-h 2048                       \
  --job-size-w 2048                       \
  --sgm-collar-size 256

point2dem -r Earth run/run-PC.tif --nodata-value -32767
