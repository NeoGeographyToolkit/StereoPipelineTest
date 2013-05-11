#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

stereo $d/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif $d/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.tif $d/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml $d/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml $dir/$dir --left-image-crop-win 1024 1024 2048 2048 --corr-max-levels 5 -t rpc -s stereo.default --alignment-method homography --subpixel-mode 1 --disable-fill-holes --threads 32 --subpixel-h-kernel 19 --subpixel-v-kernel 19 --corr-seed-mode 1

point2dem -r Earth $dir/$dir-PC.tif --nodata-value -32767
