#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.tif ../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.tif ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.xml ../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.xml run/run --disable-fill-holes --stereo-file stereo.default --left-image-crop-win 1728 665 573 653 --right-image-crop-win 1817 578 479 609 -t dg --alignment-method affineepipolar --corr-seed-mode 1 --subpixel-mode 0 --stereo-algorithm asp_sgm --corr-kernel 7 7 --xcorr-threshold 2.5 --corr-max-levels 4 --cost-mode 4  --min-num-ip 5 --save-left-right-disparity-difference --job-size-h 512 --job-size-w 512 --sgm-collar-size 256

point2dem -r Earth run/run-PC.tif --nodata-value -32767
