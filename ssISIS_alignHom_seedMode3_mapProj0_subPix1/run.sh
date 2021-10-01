#!/bin/bash

set -x verbose
rm -rfv run


stereo --enable-fill-holes ../data/M0100115.cub ../data/E0201461.cub run/run -s stereo.default --left-image-crop-win 0 1024 672 4864 --alignment-method homography --corr-seed-mode 3 --subpixel-mode 1
point2dem -r mars run/run-PC.tif --nodata-value -32767

