#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --corr-max-levels 5 -t dg --alignment-method local_epipolar --stereo-algorithm mgm --subpixel-mode 1 --disable-fill-holes --subpixel-h-kernel 19 --subpixel-v-kernel 19 --left-image-crop-win 2529 1535 707 372 --right-image-crop-win 2355 1483 768 376 --corr-tile-size 512 --sgm-collar-size 256 --corr-seed-mode 1 --stereo-file stereo.default ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml run/run

point2dem -r Earth run/run-PC.tif --nodata-value -32767 --orthoimage run/run-L.tif --orthoimage-hole-fill-len 100 --dem-hole-fill-len 100  --remove-outliers  --median-filter-params 11 15  --erode-length 2

