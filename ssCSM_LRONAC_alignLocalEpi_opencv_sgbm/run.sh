#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --left-image-crop-win 4076 4029 396 382 --right-image-crop-win 4537 4332 415 395 --corr-seed-mode 1 ../data/M181058717LE.ce.cub ../data/M181073012LE.ce.cub ../data/M181058717LE.ce.json ../data/M181073012LE.ce.json run/run --corr-tile-size 3072 --sgm-collar-size 256 --alignment-method local_epipolar --stereo-algorithm opencv_sgbm
point2dem run/run-PC.tif
