#!/bin/bash

set -x verbose
rm -rfv run

stereo --enable-fill-holes ../data/M0100115_small.cub ../data/E0201461_small.cub run/run -s stereo.default  --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1 --max-valid-triangulation-error 2
point2dem -r mars run/run-PC.tif --nodata-value -32767



