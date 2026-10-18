#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Sparse grid of sub-pixel offsets between two co-registered mapprojected
# WorldView-3 images. Writes a three-band raster (dx, dy, valid).
phase_grid ../data/grand_mesa_WV03_left.map.dg.tif ../data/grand_mesa_WV03_right.map.dg.tif run/offsets.tif --patch-size 64 --step 48 --consistency-threshold 1.0
