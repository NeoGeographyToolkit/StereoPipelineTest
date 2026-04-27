#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

# Cross-validate a vendor-provided Florida Keys water-surface raster (in
# geographic WGS84) against two equivalent representations of the same
# surface:
#   1) the same raster reprojected to local stereographic (gdalwarp)
#   2) a global best-fit plane in text format

echo "=== vendor lonlat raster vs vendor stereographic raster ===" > run/run.txt
cam_test --image ../data/left_bathy_b3_corr.tif                  \
  --cam1 ../data/left_bathy.xml                                  \
  --cam2 ../data/left_bathy.xml                                  \
  --cam1-bathy-plane ../data/water_surf_florida_keys_lonlat.tif  \
  --cam2-bathy-plane ../data/water_surf_florida_keys_stere.tif   \
  --refraction-index 1.333                                       \
  --height-above-datum -50 2>/dev/null                           \
  | grep -i -v elapsed >> run/run.txt

echo ""                                                       >> run/run.txt
echo "=== vendor lonlat raster vs best-fit plane (text) ===" >> run/run.txt
cam_test --image ../data/left_bathy_b3_corr.tif                  \
  --cam1 ../data/left_bathy.xml                                  \
  --cam2 ../data/left_bathy.xml                                  \
  --cam1-bathy-plane ../data/water_surf_florida_keys_lonlat.tif  \
  --cam2-bathy-plane ../data/water_surf_florida_keys_plane.txt   \
  --refraction-index 1.333                                       \
  --height-above-datum -50 2>/dev/null                           \
  | grep -i -v elapsed >> run/run.txt
