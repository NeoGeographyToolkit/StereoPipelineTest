#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --enable-fill-holes --processes 8 --threads-multiprocess 1 --job-size-w 1024 --job-size-h 1024 ../data/M0100115.cub ../data/E0201461.cub run/run -s stereo.default --left-image-crop-win 0 1024 250 300 --alignment-method affineepipolar --corr-seed-mode 1 --subpixel-mode 1
point2dem -r mars run/run-PC.tif --nodata-value -32767

