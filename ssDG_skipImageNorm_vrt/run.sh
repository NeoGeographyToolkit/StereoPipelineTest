#!/bin/bash

set -x verbose
rm -rfv run

# Cut a little clip and wrap it in a VRT. This exercises
# --skip-image-normalization with a virtual input (no pixel copy). The
# parallel_stereo run must leave run-L.tif and run-R.tif as VRTs rather than
# materializing them to TIFF. That is checked in validate.sh.
mkdir -p run
gdal_translate -srcwin 0 0 256 300 ../data/left.tif  run/left_clip.tif
gdal_translate -srcwin 0 0 256 300 ../data/right.tif run/right_clip.tif
gdalbuildvrt run/left_clip.vrt  run/left_clip.tif
gdalbuildvrt run/right_clip.vrt run/right_clip.tif

parallel_stereo --allow-different-mapproject-gsd run/left_clip.vrt run/right_clip.vrt ../data/left.xml ../data/right.xml run/run ../data/krigged_dem_nsidc_ndv0_fill.tif --disable-fill-holes -s stereo.default -t dg --alignment-method none --corr-seed-mode 1 --subpixel-mode 2 --skip-image-normalization --threads 1
point2dem -r Earth run/run-PC.tif --nodata-value -32767
