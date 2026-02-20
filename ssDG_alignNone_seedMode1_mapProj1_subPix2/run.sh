#!/bin/bash

set -x verbose
rm -rfv run

# Cut a little clip to speed things up
mkdir -p run
gdal_translate -srcwin 0 0 256 300 ../data/left.tif run/left_clip.tif
gdal_translate -srcwin 0 0 256 300 ../data/right.tif run/right_clip.tif

parallel_stereo --allow-different-mapproject-gsd run/left_clip.tif run/right_clip.tif ../data/left.xml ../data/right.xml run/run ../data/krigged_dem_nsidc_ndv0_fill.tif  --disable-fill-holes -s stereo.default -t dg --alignment-method none --corr-seed-mode 1 --subpixel-mode 2 --skip-image-normalization
point2dem -r Earth run/run-PC.tif --nodata-value -32767


