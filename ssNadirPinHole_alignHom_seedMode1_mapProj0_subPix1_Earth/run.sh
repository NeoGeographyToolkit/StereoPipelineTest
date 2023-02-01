#!/bin/bash

set -x verbose
rm -rfv run

stereo -t nadirpinhole --alignment-method homography ../data/DZB1212-500082L002001_crop.tif ../data/DZB1212-500082L003001_crop.tif ../data/DZB1212-500082L002001_25pct.tsai ../data/DZB1212-500082L003001_25pct.tsai run/run --left-image-crop-win 6500 4000 1500 1100 --right-image-crop-win 1403 4002 1630 1104 --horizontal-stddev 1 1 --propagate-errors

point2dem -r Earth run/run-PC.tif --nodata-value -32767 --propagate-errors

# Test for --correlator-mode. This does not produce a PC file.
stereo --correlator-mode run/run-L.tif run/run-R.tif run/run-corr

