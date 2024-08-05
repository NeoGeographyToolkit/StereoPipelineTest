#!/bin/bash

set -x verbose
rm -rfv run

# Test parallel_stereo in multiview mode (3 images and cameras)
parallel_stereo ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10_copy.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10_copy.xml run/run --left-image-crop-win 1716 1079 1285 1407 --job-size-h 800 --job-size-w 800 --corr-max-levels 5 -t dg -s stereo.default --alignment-method homography --subpixel-mode 1 --disable-fill-holes --threads-singleprocess 16 --subpixel-h-kernel 19 --subpixel-v-kernel 19 --corr-seed-mode 1

point2dem -r Earth run/run-PC.tif --nodata-value -32767 --orthoimage run/run-L.tif --orthoimage-hole-fill-len 30 --dem-hole-fill-len 30 --tr .000174961596144

