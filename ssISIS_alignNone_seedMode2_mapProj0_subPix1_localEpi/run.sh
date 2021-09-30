#!/bin/bash

set -x verbose
rm -rfv run
stereo --enable-fill-holes ../data/M0100115_crop.cub ../data/E0201461.cub run/run -s stereo.default --left-image-crop-win 0 1024 672 4864  --disparity-estimation-dem ../data/ref-DEM.tif --disparity-estimation-dem-error 5 --alignment-method none --corr-seed-mode 2 --subpixel-mode 1 --use-local-homography
point2dem -r mars run/run-PC.tif --nodata-value -32767
