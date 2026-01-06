#!/bin/bash

set -x verbose
rm -rfv run

bathy_plane_calc                               \
  --lon-lat-measurements ../data/bathy_llh.csv \
  --csv-format "2:lon 3:lat"                   \
  --dem ../data/nobathy-DEM.tif                \
  --outlier-threshold 0.5                      \
  --bathy-plane run/meas_plane.txt             \
  --output-inlier-shapefile run/meas_inliers.shp
