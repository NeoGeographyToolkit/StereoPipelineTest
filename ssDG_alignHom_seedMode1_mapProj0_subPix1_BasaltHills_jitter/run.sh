#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10_crop.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10_crop.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml --image-lines-per-piecewise-adjustment 1000 --num-matches-for-piecewise-adjustment 1000 run/run --corr-seed-mode 0 --corr-search -20 -20 20 20 --threads 1 # need one thread to make jitter correction predictable

point2dem -r Earth run/run-PC.tif --nodata-value -32767 --orthoimage run/run-L.tif --orthoimage-hole-fill-len 100 --dem-hole-fill-len 100 --tr .000174961596144 --remove-outliers  --median-filter-params 11 15  --erode-length 2

