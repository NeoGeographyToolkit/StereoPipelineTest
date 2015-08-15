#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/WV01_11JAN131652222-P1BS-10200100104A0300_sub8.tif ../data/WV01_11JAN131653180-P1BS-1020010011862E00_sub8.tif ../data/WV01_11JAN131652222-P1BS-10200100104A0300_sub8.xml ../data/WV01_11JAN131653180-P1BS-1020010011862E00_sub8.xml run/run -s stereo.default --disable-fill-holes --corr-search -15 -15 15 15 --left-image-crop-win 4096 2048 512 512 -t rpc --alignment-method none --corr-seed-mode 1 --subpixel-mode 1
point2dem -r Earth run/run-PC.tif --nodata-value -32767
