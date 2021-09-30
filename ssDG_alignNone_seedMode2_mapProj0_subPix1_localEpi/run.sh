#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/WV01_11JAN131652222-P1BS-10200100104A0300_sub8.tif ../data/WV01_11JAN131653180-P1BS-1020010011862E00_sub8.tif ../data/WV01_11JAN131652222-P1BS-10200100104A0300_sub8.xml ../data/WV01_11JAN131653180-P1BS-1020010011862E00_sub8.xml run/run -s stereo.default -t dg --disable-fill-holes --left-image-crop-win 2048 2048 400 400 --disparity-estimation-dem ../data/krigged_dem_nsidc_ndv0_fill.tif --disparity-estimation-dem-error 2 --alignment-method none --corr-seed-mode 2 --subpixel-mode 1 --use-local-homography
point2dem -r Earth run/run-PC.tif --nodata-value -32767

