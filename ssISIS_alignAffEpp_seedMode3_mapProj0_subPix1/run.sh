#!/bin/bash

set -x verbose
rm -rfv run

stereo --enable-fill-holes ../data/M0100115.cub ../data/E0201461.cub run/run -s stereo.default --left-image-crop-win 0 1024 672 1200 --alignment-method affineepipolar --subpixel-mode 1 --verbose
point2dem -r mars --gnomonic --proj-lon 141.5608796 --proj-lat 34.2926059 run/run-PC.tif

