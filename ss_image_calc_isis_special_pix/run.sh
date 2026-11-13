#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

# ../data/special_pix.cub is a small manufactured float32 ISIS cube: a row of
# valid values and a row holding all five ISIS Real special pixels (Null, Lrs,
# Lis, His, Hrs), whose bit patterns read as values near -3.4e38. GDAL maps only
# Null to nodata, so image_calc must apply its ISIS valid-range masking to turn
# the other four into the output nodata.
image_calc -o run/output.tif -d float32 -c "var_0" \
  ../data/special_pix.cub --output-nodata-value -32768
