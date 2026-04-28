#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

# Fit a plane to a Florida Keys vendor water-surface raster (geographic
# WGS84) using bathy_plane_calc --water-surface. The same raster is used
# in ss_cam_test_lonlat_surface for the cam_test bathy regression.

bathy_plane_calc                                             \
  --water-surface ../data/water_surf_florida_keys_lonlat.tif \
  --bathy-plane run/plane.txt
