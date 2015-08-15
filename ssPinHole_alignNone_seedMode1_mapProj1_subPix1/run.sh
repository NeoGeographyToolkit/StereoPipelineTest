#!/bin/bash

set -x verbose
rm -rfv run

stereo -t pinholemappinhole ../data/DZB1212-500082L002001_bb_mapproj_1e4.tif ../data/DZB1212-500082L003001_bb_mapproj_1e4.tif ../data/DZB1212-500082L002001_bb_50pct_2x.pinhole ../data/DZB1212-500082L003001_bb_50pct_2x.pinhole run/run ../data/good_dem.tif -s stereo.default --corr-seed-mode 1 --subpixel-mode 1 --left-image-crop-win 3701 751 1165 988 --right-image-crop-win 3672 810 1091 900

point2dem --nodata-value -32767 --semi-major-axis 1 --semi-minor-axis 1 run/run-PC.tif


