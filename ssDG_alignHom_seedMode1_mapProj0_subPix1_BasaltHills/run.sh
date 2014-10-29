#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml run/run --left-image-crop-win 1024 1024 2048 2048 --corr-max-levels 5 -t dg -s stereo.default --alignment-method homography --subpixel-mode 1 --disable-fill-holes --threads 32 --subpixel-h-kernel 19 --subpixel-v-kernel 19 --corr-seed-mode 1

point2dem -r Earth run/run-PC.tif --nodata-value -32767 --orthoimage run/run-L.tif --orthoimage-hole-fill-len 100 --dem-hole-fill-len 100 --tr .000174961596144 --remove-outliers  --median-filter-params 11 15

