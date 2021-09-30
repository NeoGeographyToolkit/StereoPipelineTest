#!/bin/bash

set -x verbose
rm -rfv run

# This is not a great testcase but the best available so far 
stereo ../data/LSZ_01636_1CD_XKU_09N120_S1.8bit.map.cub ../data/LSZ_02330_1CD_XKU_00S120_S1.8bit.map.cub run/run --left-image-crop-win 1816 42536 570 635 --right-image-crop-win 180 3876 640 657 --outlier-removal-params 100 3

point2dem run/run-PC.tif

