#!/bin/bash

set -x verbose
rm -rfv run

stereo --corr-timeout 3000 --enable-fill-holes ../data/M0100115.map.small.tif ../data/E0201461.map.small.tif ../data/M0100115.cub ../data/E0201461.cub  run/run ../data/M0100115_dem_lowRes.tif -s stereo.default --alignment-method none --corr-seed-mode 1 --subpixel-mode 1 -t isismapisis 
point2dem -r mars run/run-PC.tif --nodata-value -32767



