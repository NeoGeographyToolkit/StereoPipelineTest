#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/M0100115_crop.cub ../data/E0201461.cub run/run -s stereo.default --disable-fill-holes --left-image-crop-win 0 1024 672 4864 --disparity-estimation-dem ../data/ref-DEM.tif --disparity-estimation-dem-error 5 --alignment-method affineepipolar --corr-seed-mode 2  --stereo-algorithm 2 --corr-tile-size 2000
point2dem -r mars run/run-PC.tif --nodata-value -32767



