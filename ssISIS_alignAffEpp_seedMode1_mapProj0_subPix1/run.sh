#!/bin/bash

set -x verbose
rm -rfv run

stereo --corr-timeout 6000 --enable-fill-holes ../data/M0100115.cub ../data/E0201461.cub run/run -s stereo.default --left-image-crop-win 0 1024 672 1200 --alignment-method affineepipolar --corr-seed-mode 1 --subpixel-mode 1
point2dem -r mars run/run-PC.tif --nodata-value -32767



