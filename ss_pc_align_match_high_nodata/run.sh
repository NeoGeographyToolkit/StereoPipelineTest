#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Regression test for the pc_align match-file no-data masking fix.
# Reuse the tracked pluto DEMs but remap the no-data sentinel to a HIGH value
# (65535), which is above the actual elevations (~ -6305 .. 6480 m). gdalwarp
# rewrites the no-data corner pixels to 65535 (a true sentinel in the pixels)
# without resampling, so the grid and the interior data the match file indexes
# stay unchanged. This reproduces the vendor-DEM case (no-data 65535 with
# negative elevations) that exposed the bug: the old "h <= no-data" check voided
# every match because every elevation is <= 65535, throwing "Not enough valid
# matches". With the create_mask fix (exact no-data compare), the 65535 pixels
# are masked correctly and every interior elevation survives, so pc_align
# computes the same transform as in the low-no-data case.
gdalwarp -overwrite -dstnodata 65535 ../data/pluto-dem1.tif run/dem1-highndv.tif
gdalwarp -overwrite -dstnodata 65535 ../data/pluto-dem2.tif run/dem2-highndv.tif

pc_align run/dem1-highndv.tif run/dem2-highndv.tif --match-file ../data/pluto1-pluto2.match --max-displacement -1 --num-iterations 0 -o run/run
