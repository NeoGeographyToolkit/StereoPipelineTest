#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Input DEM with NO nodata value. The nodata tag was stripped once, when the
# dataset was created, from a copy of basalt_dem_crop.tif with
# "gdal_edit.py -unsetnodata" (image_calc itself has no option to strip nodata).
# The former fill pixels (value -32767) are still present in the raster.
in=../data/basalt_dem_crop_nonodata.tif

# Declare an input nodata with --input-nodata-value but do NOT set
# --output-nodata-value. image_calc then falls back to the type-aware default
# output nodata. For float32 that default is -1e6 (clean and exactly
# representable), not the old -FLT_MAX (~-3.4e38, not exactly representable and
# printed with reduced precision). The -32767 pixels become -1e6 in the output.
image_calc -c "var_0" --input-nodata-value -32767 -d float32 \
  $in -o run/out_float.tif
