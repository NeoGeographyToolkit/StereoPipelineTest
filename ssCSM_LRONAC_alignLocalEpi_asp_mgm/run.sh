#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --left-image-crop-win 3583 3922 1767 1691 --right-image-crop-win 4095 4348 1498 1668 --threads 16 --corr-seed-mode 1 ../data/M181058717LE.ce.cub ../data/M181073012LE.ce.cub ../data/M181058717LE.ce.json ../data/M181073012LE.ce.json run/run --corr-tile-size 3072 --sgm-collar-size 256 --alignment-method local_epipolar --stereo-algorithm asp_mgm
point2dem run/run-PC.tif
