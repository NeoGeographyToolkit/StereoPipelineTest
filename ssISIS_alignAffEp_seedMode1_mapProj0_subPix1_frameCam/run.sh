#!/bin/bash

set -x verbose
rm -rfv run

stereo --corr-timeout 6000  ../data/AS15-M-0759.lev1_crop.cub ../data/AS15-M-0760.lev1_crop.cub run/run --alignment-method affineepipolar --subpixel-mode 1 --disable-fill-holes --left-image-crop-win 1024 1024 1024 1024 --threads 1 --ip-detect-method 1

point2dem -r moon run/run-PC.tif --nodata-value -32767 --errorimage  

