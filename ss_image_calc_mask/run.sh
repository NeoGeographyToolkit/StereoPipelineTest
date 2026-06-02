#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Base DEM (heights roughly 104 to 635 m).
base=../data/basalt_dem_crop.tif

# Make an "honest" DEM with legitimate 0-height pixels: clamp from below at
# 300 m, then shift so 300 becomes 0. Pixels at or below 300 m become height 0.
# The input nodata is propagated to the output nodata value (-9999).
image_calc -c "max(300, var_0) - 300" -d float32 --output-nodata-value -9999 \
  $base -o run/dem_clip_min_ht0.tif

# Make a mask that is 1 wherever the DEM is valid. The + 1 avoids 0/0 at the
# legitimate 0-height pixels (the honest DEM is >= 0, so var_0 + 1 >= 1).
image_calc -c "(var_0 + 1) / (var_0 + 1)" -d float32 --output-nodata-value -9999 \
  run/dem_clip_min_ht0.tif -o run/mask_clip.tif

# Apply the mask. This is the command documented in image_calc.rst
# (image_calc_mask): set masked pixels to a nodata value outside the data
# range, so a legitimate 0-height pixel stays a valid 0, not nodata.
image_calc -c "eq(var_1, 0, -9999, var_0)" -d float32 --output-nodata-value -9999 \
  run/dem_clip_min_ht0.tif run/mask_clip.tif -o run/masked_new.tif

# For contrast: the old multiply-by-mask approach with nodata 0 marks every
# legitimate 0-height pixel as invalid.
image_calc -c "var_0 * var_1" -d float32 --output-nodata-value 0 \
  run/dem_clip_min_ht0.tif run/mask_clip.tif -o run/masked_old.tif
