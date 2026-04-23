#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

# cam_test with a georeferenced image as the bathy plane input. The reader
# in vw::readBathyPlane detects the GeoTIFF, fits a best-fit plane via SVD,
# and passes the plane coefficients to cam_test exactly like the text path.
cam_test --image ../data/left_bathy_b3_corr.tif \
  --cam1 ../data/left_bathy.xml \
  --cam2 ../data/left_bathy.xml \
  --bathy-plane ../data/water_surface.tif \
  --refraction-index 1.333 \
  --height-above-datum -16 2>/dev/null \
  | grep -E 'Reading bathy|Fitted bathy|Mean plane|Projection:' \
  > run/run.txt
