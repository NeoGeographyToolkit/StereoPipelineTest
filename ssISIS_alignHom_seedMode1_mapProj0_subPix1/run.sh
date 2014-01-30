#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/M0100115.cub ../data/E0201461.cub run/run -s stereo.default --left-image-crop-win 0 1024 672 4864 --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1 --filter-mode 2
point2dem -r mars run/run-PC.tif --nodata-value -32767 --errorimage --fsaa 4




