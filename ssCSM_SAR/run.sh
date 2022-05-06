#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo ../data/lsz_03821_1cd_xku_16n196_v1_clamp_crop.tif ../data/lsz_03822_1cd_xku_23n196_v1_clamp_crop.tif ../data/lsz_03821_1cd_xku_16n196_v1.json ../data/lsz_03822_1cd_xku_23n196_v1.json --stereo-algorithm asp_mgm --skip-rough-homography --no-datum --ip-per-tile 6000 --left-image-crop-win 469 8005 1831 1822 --right-image-crop-win 562 27190 1404 1696 run/run

point2dem run/run-PC.tif

