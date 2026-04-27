#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

# Cross-validate the analytical bathy plane (text format) against equivalent
# raster representations of the SAME plane:
#   - synth_water_surface_stere.tif  : exact sampling on a stereographic grid
#   - synth_water_surface_lonlat.tif : reprojection of the above to EPSG:4326
# Both rasters are synthesized from bathy-plane.txt by
# ~/projects/sdb/make_synth_water_surface.sh, so they describe the same
# surface as the text plane up to numerical noise. The pixel-diff metric
# printed by cam_test is the equivalence oracle.

echo "analytical text plane vs stereographic raster" > run/run.txt
cam_test --image ../data/left_bathy_b3_corr.tif                 \
  --cam1 ../data/left_bathy.xml                                 \
  --cam2 ../data/left_bathy.xml                                 \
  --cam1-bathy-plane ../data/bathy-plane.txt                    \
  --cam2-bathy-plane ../data/synth_water_surface_stere.tif      \
  --refraction-index 1.333                                      \
  --height-above-datum -50                                      \
  | grep -i -v elapsed >> run/run.txt

echo ""                                              >> run/run.txt
echo "analytical text plane vs lon-lat raster" >> run/run.txt
cam_test --image ../data/left_bathy_b3_corr.tif                 \
  --cam1 ../data/left_bathy.xml                                 \
  --cam2 ../data/left_bathy.xml                                 \
  --cam1-bathy-plane ../data/bathy-plane.txt                    \
  --cam2-bathy-plane ../data/synth_water_surface_lonlat.tif     \
  --refraction-index 1.333                                      \
  --height-above-datum -50                                      \
  | grep -i -v elapsed >> run/run.txt
