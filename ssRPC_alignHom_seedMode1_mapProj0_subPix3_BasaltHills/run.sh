#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml run/run --left-image-crop-win 1024 1024 2048 2048 --corr-max-levels 5 -t rpc -s stereo.default --alignment-method homography --subpixel-mode 3 --disable-fill-holes --subpixel-h-kernel 19 --subpixel-v-kernel 19 --corr-seed-mode 1 --bundle-adjust-prefix ../data/rpc_ba/run --threads 3 --compute-point-cloud-covariances

point2dem -r Earth run/run-PC.tif --nodata-value -32767 --remove-outliers --covariances

