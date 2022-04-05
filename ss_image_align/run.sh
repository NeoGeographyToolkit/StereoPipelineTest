#!/bin/bash

set -x verbose
rm -rfv run

image_align ../data/image_crop.tif ../data/image_crop_4.5pix.tif -o run/run-align.tif --output-prefix run/run

# Now do the same thing using the disparity. Note how we invert the order of images when we find it.
parallel_stereo --correlator-mode  ../data/image_crop.tif ../data/image_crop_4.5pix.tif run/run-corr --stereo-algorithm asp_mgm --subpixel-mode 2
image_align ../data/image_crop.tif ../data/image_crop_4.5pix.tif -o run/run-corr-align.tif --output-prefix run/run-corr \
  --disparity-params "run/run-corr-F.tif 1000000"

