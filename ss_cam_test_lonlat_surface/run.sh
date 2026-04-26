#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

# cam_test with a real-world water-surface raster in geographic WGS84
# (0-360 longitude convention) as the bathy-plane input.
cam_test --image ../data/left_bathy_b3_corr.tif \
  --cam1 ../data/left_bathy.xml \
  --cam2 ../data/left_bathy.xml \
  --cam1-bathy-plane ../data/water_surf_florida_keys_lonlat.tif \
  --cam2-bathy-plane ../data/water_surf_florida_keys_lonlat.tif \
  --refraction-index 1.333 \
  --height-above-datum -16 2>/dev/null \
  | grep -i -v elapsed > run/run.txt

