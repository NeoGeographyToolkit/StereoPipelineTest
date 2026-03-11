#!/bin/bash

set -x verbose
rm -rfv run

stereo --matches-as-txt --left-image-crop-win 1346 9946 600 600 --right-image-crop-win 1903 10078 700 700 --corr-seed-mode 1 ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub run/run 
point2dem -r mars run/run-PC.tif --nodata-value -32767

