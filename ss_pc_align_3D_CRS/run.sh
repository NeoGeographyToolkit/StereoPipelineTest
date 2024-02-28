#!/bin/bash

set -x verbose
rm -rfv run

# This tests a 3D CRS. The file ../data/COP30_E_crop.tif.aux.xml has the projection and must not be deleted.
pc_align --max-displacement -1  \
  --save-transformed-source-points --save-inv-transformed-reference-points \
  ../data/COP30_E_crop.tif ../data/aster_crop.tif -o run/run

