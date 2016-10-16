#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.tif ../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.tif ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.xml ../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.xml run/run --disable-fill-holes --stereo-file stereo.default --left-image-crop-win 2758 399 256 256   --right-image-crop-win 2605 554 256 256 -t dg --alignment-method affineepipolar --corr-seed-mode 1 --subpixel-mode 0 --stereo-algorithm 1 --corr-kernel 7 7 --xcorr-threshold -1 --corr-max-levels 4 --cost-mode 4 --threads 1 

point2dem -r Earth run/run-PC.tif --nodata-value -32767
