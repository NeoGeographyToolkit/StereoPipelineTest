#!/bin/bash

set -x verbose
rm -rfv run

image_align --matches-as-txt ../data/image_crop.tif ../data/image_crop_4.5pix.tif -o run/run-align.tif --output-prefix run/run --alignment-transform translation

# Now do the same thing using the disparity. Note how we invert the order of images when we find it.
# Also save the left-right disparity difference and pass it as the third entry of
# --disparity-params, so each match's sigma is the per-match uncertainty (floored at 0.5).
parallel_stereo --correlator-mode  ../data/image_crop.tif ../data/image_crop_4.5pix.tif run/run-corr --stereo-algorithm asp_mgm --subpixel-mode 2 --save-left-right-disparity-difference
image_align --matches-as-txt ../data/image_crop.tif ../data/image_crop_4.5pix.tif -o run/run-corr-align.tif --output-prefix run/run-corr \
  --disparity-params "run/run-corr-F.tif 1000000 run/run-corr-L-R-disp-diff.tif" --alignment-transform translation

