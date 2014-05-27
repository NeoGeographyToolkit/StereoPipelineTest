#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/left.tif ../data/right.tif ../data/left.xml ../data/right.xml run/run ../data/krigged_dem_nsidc_ndv0_fill.tif -s stereo.default -t dg --left-image-crop-win 0 0 150 150 --alignment-method none --corr-seed-mode 1 --subpixel-mode 2 
point2dem -r Earth run/run-PC.tif --nodata-value -32767

