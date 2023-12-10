#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo  --corr-tile-size 3072 --sgm-collar-size 256 --alignment-method local_epipolar --stereo-algorithm msmw --corr-timeout 10000 --left-image-crop-win 2710 4110 370 354 --right-image-crop-win 3039 4456 417 495 --corr-seed-mode 1 --compute-low-res-disparity-only ../data/M181058717LE.ce.cub ../data/M181073012LE.ce.cub ../data/M181058717LE.ce.json ../data/M181073012LE.ce.json run/run
point2dem run/run-PC.tif
