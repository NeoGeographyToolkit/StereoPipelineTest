#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

# Cross-validate Monica's real Florida Keys water surface against two
# alternative representations of the SAME physical surface:
#   1) the same surface reprojected to local stereographic (gdalwarp output)
#   2) a global best-fit plane (text format) sampled from the same data
# Both alternatives are produced by ~/projects/sdb/make_monica_derivatives.sh
# and live in StereoPipelineTest/data/ (gitignored, rsynced manually).

echo "=== Monica lonlat raster vs Monica stereographic raster ===" > run/run.txt
cam_test --image ../data/left_bathy_b3_corr.tif                               \
  --cam1 ../data/left_bathy.xml                                               \
  --cam2 ../data/left_bathy.xml                                               \
  --cam1-bathy-plane ../data/water_surf_florida_keys_lonlat.tif               \
  --cam2-bathy-plane ../data/monica_florida_water_surface_stere.tif           \
  --refraction-index 1.333                                                    \
  --height-above-datum -50 2>/dev/null                                        \
  | grep -i -v elapsed >> run/run.txt

echo ""                                                            >> run/run.txt
echo "=== Monica lonlat raster vs analytical best-fit plane ===" >> run/run.txt
cam_test --image ../data/left_bathy_b3_corr.tif                               \
  --cam1 ../data/left_bathy.xml                                               \
  --cam2 ../data/left_bathy.xml                                               \
  --cam1-bathy-plane ../data/water_surf_florida_keys_lonlat.tif               \
  --cam2-bathy-plane ../data/monica_florida_best_fit_plane.txt                \
  --refraction-index 1.333                                                    \
  --height-above-datum -50 2>/dev/null                                        \
  | grep -i -v elapsed >> run/run.txt
