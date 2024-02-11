#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml run/run --corr-max-levels 5 -t rpc -s stereo.default --alignment-method homography --subpixel-mode 3 --disable-fill-holes --subpixel-h-kernel 19 --subpixel-v-kernel 19 --corr-seed-mode 1 --bundle-adjust-prefix ../data/rpc_ba/run --threads 3 --propagate-errors --left-image-crop-win 1553 1335 677 518 --right-image-crop-win 1617 1170 450 390

# Test error propagation and using an UTM projection
srs='+proj=utm +zone=10 +datum=WGS84 +units=m +no_defs'
point2dem -r Earth --t_srs "$srs" run/run-PC.tif --nodata-value -32767 --remove-outliers --propagate-errors

