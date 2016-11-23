#!/bin/bash

set -x verbose
rm -rfv run

stereo -t pinholemappinhole ../data/pinhole_proj_47.tif ../data/pinhole_proj_48.tif ../data/pinhole_proj_47.tif.tsai ../data/pinhole_proj_48.tif.tsai   run/run ../data/krigged_dem_nsidc_ndv0_fill.tif -s stereo.default --corr-seed-mode 1 --subpixel-mode 1

point2dem --nodata-value -32767 run/run-PC.tif


