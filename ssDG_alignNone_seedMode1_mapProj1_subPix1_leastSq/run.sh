#!/bin/bash

d=../data
dir=run
rm -rfv $dir

stereo $d/left.tif $d/right.tif $d/left.xml $d/right.xml $dir/$dir $d/krigged_dem_nsidc_ndv0_fill.tif -s stereo.default -t dg --left-image-crop-win 0 0 150 150 --alignment-method none --corr-seed-mode 1 --subpixel-mode 1 --use-least-squares
point2dem -r Earth $dir/$dir-PC.tif --nodata-value -32767

