#!/bin/bash

set -x verbose
rm -rfv run

bathy_plane_calc                          \
  --shapefile ../data/bathy_shoreline.shp \
  --dem ../data/nobathy-DEM.tif           \
  --outlier-threshold 0.2                 \
  --bathy-plane run/bathy-plane.txt       \
  --output-inlier-shapefile run/inliers.shp
