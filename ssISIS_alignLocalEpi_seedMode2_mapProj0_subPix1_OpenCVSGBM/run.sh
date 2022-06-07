#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo ../data/M0100115_crop2.cub ../data/E0201461_crop.cub run/run --left-image-crop-win 0 124 672 4864 --disparity-estimation-dem ../data/seed-mode-2-init-DEM.tif --disparity-estimation-dem-error 5 --alignment-method local_epipolar --corr-seed-mode 2 --stereo-algorithm opencv_sgbm

point2dem -r mars run/run-PC.tif --nodata-value -32767
