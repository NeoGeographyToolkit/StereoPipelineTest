#!/bin/bash

set -x verbose
rm -rfv run

# Run parallel stereo with two small tiles
parallel_stereo --processes 4 --left-image-crop-win 139 1500 415 793 --right-image-crop-win 335 1239 680 1134 --job-size-h 600 --job-size-w 600 --sgm-collar-size 100 --alignment-method local_epipolar  --compute-error-vector --stereo-algorithm asp_mgm --corr-seed-mode 1 ../data/M0100115_crop.cub ../data/E0201461.cub run/run --cost-mode 3 --corr-kernel 9 9

point2dem -r mars run/run-PC.tif --nodata-value -32767 --errorimage

