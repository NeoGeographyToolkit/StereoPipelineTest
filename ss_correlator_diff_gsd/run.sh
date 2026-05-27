#!/bin/bash

rm -rfv run
mkdir -p run

# Create a copy of image_crop.tif with slightly different GSD (1e-3 relative)
gdalwarp -r cubicspline \
  -tr 0.000556111111111556 0.000556111111111556 \
  ../data/image_crop.tif run/image_crop_diff_gsd.tif

parallel_stereo --correlator-mode          \
  --stereo-algorithm asp_mgm --subpixel-mode 2 \
  ../data/image_crop.tif                   \
  run/image_crop_diff_gsd.tif              \
  run/run > run/output.txt 2>&1
