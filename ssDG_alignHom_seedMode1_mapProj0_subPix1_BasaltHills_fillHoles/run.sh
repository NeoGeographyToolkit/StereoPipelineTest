#!/bin/bash

set -x verbose
rm -rfv run

stereo --enable-fill-holes --corr-max-levels 5 --alignment-method homography --subpixel-mode 1 --subpixel-h-kernel 19 --subpixel-v-kernel 19 --left-image-crop-win 1598 1320 639 564 --right-image-crop-win 1557 1162 624 511 --threads 32 --corr-seed-mode 1 --session-type dg --stereo-file stereo.default ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml run/run 

point2dem -r Earth run/run-PC.tif --nodata-value -32767
