#!/bin/bash

set -x verbose
rm -rfv run

stereo -t nadirpinhole ../data/1n270487304eff90cip1952l0m1.tif ../data/1n270487304eff90cip1952r0m1.tif ../data/1n270487304eff90cip1952l0m1.cahvor ../data/1n270487304eff90cip1952r0m1.cahvor run/run -s stereo.default --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1
point2dem --nodata-value -32767 --semi-major-axis 1 --semi-minor-axis 1 run/run-PC.tif


