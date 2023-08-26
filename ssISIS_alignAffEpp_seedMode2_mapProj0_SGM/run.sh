#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo ../data/M0100115_crop.cub ../data/E0201461.cub run/run -s stereo.default --disable-fill-holes --left-image-crop-win 0 1024 672 4864 --disparity-estimation-dem ../data/seed-mode-2-init-DEM.tif --disparity-estimation-dem-error 5 --alignment-method affineepipolar --corr-seed-mode 1  --stereo-algorithm asp_mgm --corr-tile-size 2000 --cost-mode 4 --corr-kernel 9 9
point2dem -r mars run/run-PC.tif --nodata-value -32767

