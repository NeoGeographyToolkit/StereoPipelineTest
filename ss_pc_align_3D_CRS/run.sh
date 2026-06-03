#!/bin/bash

# Test pc_align with a 3D compound CRS (EPSG:32610+5773, UTM 10N + EGM96 height).
# The CRS is baked into ../data/COP30_E_crop.tif with:
#   gdal_edit.py -a_srs "EPSG:32610+5773" ../data/COP30_E_crop.tif

set -x verbose
rm -rfv run
pc_align --max-displacement -1  \
  --save-transformed-source-points --save-inv-transformed-reference-points \
  ../data/COP30_E_crop.tif ../data/aster_crop.tif -o run/run

