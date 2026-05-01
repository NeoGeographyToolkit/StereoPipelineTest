#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub ../data/B17_016219_1978_XN_17N282W.8bit.json ../data/B18_016575_1978_XN_17N282W.8bit.json run/run --ip-detect-method 2 --corr-tile-size 3072 --alignment-method local_epipolar --stereo-algorithm libelas --left-image-crop-win 2666 2160 456 491 --right-image-crop-win 3477 2453 421 408 --corr-seed-mode 1 --sgm-collar-size 256
point2dem -r mars run/run-PC.tif --nodata-value -32767
