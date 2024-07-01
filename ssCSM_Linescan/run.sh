#!/bin/bash

set -x verbose
rm -rfv run

# Test stereo with CSM cameras and the ORB ip detect method
stereo --left-image-crop-win 2057 10449 364 328 --right-image-crop-win 2695 10691 485 358 --corr-seed-mode 1 ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub ../data/B17_016219_1978_XN_17N282W.8bit.json ../data/B18_016575_1978_XN_17N282W.8bit.json run/run --ip-detect-method 2
point2dem -r mars run/run-PC.tif --nodata-value -32767

