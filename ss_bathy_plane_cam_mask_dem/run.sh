#!/bin/bash

set -x verbose
rm -rfv run

# Find the bathy plane using a DEM, a mask, and a camera
bathy_plane_calc                                     \
  --dem ../data/nobathy-DEM.tif                      \
  --mask ../data/left_bathy_b7_mask.tif              \
  --camera ../data/left_bathy.xml                    \
  --bathy-plane run/mask-bathy-plane.txt             \
  --outlier-threshold 0.5                            \
  --output-inlier-shapefile run/run-mask-inliers.shp \
  --num-samples 10000

