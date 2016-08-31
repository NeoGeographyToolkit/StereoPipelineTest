#!/bin/bash

set -x verbose
rm -rfv run

# TODO: Improve SGM algorithm, remove the bad spot in the bottom left corner of the results.

stereo --corr-timeout 6000 ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.tif ../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.tif ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.xml ../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.xml run/run --disable-fill-holes --stereo-file stereo.default --left-image-crop-win 2758 399 676 691 --right-image-crop-win 2605 554 614 607 -t dg --alignment-method affineepipolar --corr-seed-mode 1 --subpixel-mode 0 --use-sgm --corr-kernel 5 5 --xcorr-threshold -1 --corr-max-levels 3

point2dem -r Earth run/run-PC.tif --nodata-value -32767
