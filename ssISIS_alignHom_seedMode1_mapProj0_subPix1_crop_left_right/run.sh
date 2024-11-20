#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --enable-fill-holes ../data/M0100115.cub ../data/E0201461.cub run/run -s stereo.default  --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1 --filter-mode 2 --left-image-crop-win 100 2200 1000 2000 --right-image-crop-win 201 1600 1200 1983
point2dem -r mars run/run-PC.tif --nodata-value -32767 --errorimage  

