#!/bin/bash

set -x verbose
rm -rfv run

# How to make an ortho mask
#image_calc -c "gte(var_0, $thresh, 1, 0)" -d float32 ../data/left_bathy_b7.map.tif -o ../data/left_bathy_b7_mask.map.tif --output-nodata-value -1e+6

# Find the bathy plane using a DEM and an orthomask
bathy_plane_calc                                     \
  --dem ../data/nobathy-DEM.tif                      \
  --ortho-mask ../data/left_bathy_b7_mask.map.tif    \
  --bathy-plane run/mask-bathy-plane.txt             \
  --outlier-threshold 0.5                            \
  --output-inlier-shapefile run/run-mask-inliers.shp \
  --num-samples 10000

