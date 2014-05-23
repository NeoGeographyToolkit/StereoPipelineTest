#!/bin/bash

set -x verbose
rm -rfv run

stereo --save-double-precision-point-cloud ../data/M0100115_small.cub ../data/E0201461_small.cub run/run -s stereo.default --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1
point2dem run/run-PC.tif --nodata-value -32767 --max-valid-triangulation-error 2 --semi-major-axis 3396180 --semi-minor-axis 3396170


