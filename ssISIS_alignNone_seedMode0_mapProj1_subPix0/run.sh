#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/M0100115.map.cub ../data/E0201461.map.cub run/run -s stereo.default --corr-search -300 -300 -200 -200 --left-image-crop-win 0 1024 672 4864 --alignment-method none --corr-seed-mode 0 --subpixel-mode 0
point2dem -r mars run/run-PC.tif --nodata-value -32767

