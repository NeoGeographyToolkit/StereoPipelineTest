#!/bin/bash

set -x verbose
rm -rfv run

# Test blending with external weights

mkdir -p run

ls ../data/stereo_sub10/*/run-DEM.tif  > run/dem_list.txt
ls ../data/stereo_sub10/*/run-VerticalStdDev.tif > run/vert_list.txt

dem_mosaic \
  --dem-list run/dem_list.txt \
  --weight-list run/vert_list.txt \
  --invert-weights \
  -o run/dem_mosaic.tif
  
