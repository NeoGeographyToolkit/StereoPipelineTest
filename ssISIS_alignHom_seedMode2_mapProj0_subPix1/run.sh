#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/M0100115_crop.cub ../data/E0201461.cub run/run -s stereo.default --disable-fill-holes --left-image-crop-win 0 1024 672 1200 --disparity-estimation-dem ../data/seed-mode-2-init-DEM.tif --disparity-estimation-dem-error 5 --alignment-method homography --corr-seed-mode 2 --subpixel-mode 1
point2dem -r mola run/run-PC.tif --nodata-value -32767

