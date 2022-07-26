#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --verbose --job-size-w 512 --job-size-h 1024 --corr-timeout 600 ../data/1n270487304eff90cip1952l0m1.tif ../data/1n270487304eff90cip1952r0m1.tif ../data/1n270487304eff90cip1952l0m1.cahvor ../data/1n270487304eff90cip1952r0m1.cahvor run/run -s stereo.default  --left-image-crop-win 515 609 605 450 --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1 --corr-tile-size 512 --keep-only "-RD.tif -PC.tif -DEM.tif .vwip .exr .match"
point2dem --nodata-value -32767 --semi-major-axis 1 --semi-minor-axis 1 run/run-PC.tif
