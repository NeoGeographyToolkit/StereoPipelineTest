#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --left-image-crop-win 3583 3922 1767 1691 --right-image-crop-win 4095 4348 1498 1668 --threads 16 --corr-seed-mode 1 ../data/M181058717LE.ce.cub ../data/M181073012LE.ce.cub ../data/M181058717LE.ce.json ../data/M181073012LE.ce.json run/run --corr-tile-size 3072 --sgm-collar-size 256 --alignment-method affineepipolar --stereo-algorithm asp_bm --save-left-right-disparity-difference

point2dem run/run-PC.tif

corr_eval run/run-L.tif run/run-R.tif run/run-F.tif run/run-F-ncc.tif

