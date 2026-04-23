#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

# cam_test with a real-world water-surface raster in geographic WGS84
# (0-360 longitude convention) as the bathy-plane input. Exercises the
# VW reader in vw::readBathyPlane end-to-end: detect GeoTIFF, fit a
# plane via least-squares-on-height in the raster's own coordinates,
# feed the coefficients to cam_test.
#
# Note: the downstream Snell's-law math in rayBathyPlaneIntersect
# assumes plane_proj has meter-scale horizontal axes. A lon-lat
# plane_proj produces coefficients in mixed units; the fit itself is
# tight (residuals at cm scale for this raster), but callers should
# be aware - see the TODO in vw/Cartography/SnellLaw.cc.
cam_test --image ../data/left_bathy_b3_corr.tif \
  --cam1 ../data/left_bathy.xml \
  --cam2 ../data/left_bathy.xml \
  --bathy-plane ../data/water_surf_florida_keys_lonlat.tif \
  --refraction-index 1.333 \
  --height-above-datum -16 2>/dev/null \
  | grep -E 'Reading bathy|Fitted bathy|Plane-fit|Projection:' \
  > run/run.txt
