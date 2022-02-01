#!/bin/bash

set -x verbose
rm -rfv run

stereo --left-image-crop-win 1346 9746 1034 1003 --right-image-crop-win 1903 9778 1162 1210 --corr-seed-mode 1 ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub run/run 
point2dem -r mars run/run-PC.tif --nodata-value -32767

