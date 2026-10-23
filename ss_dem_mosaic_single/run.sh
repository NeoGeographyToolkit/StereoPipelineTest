#!/bin/bash

set -x verbose
rm -rfv run

# Mosaicking a single DEM must return that same DEM. The blending weight is
# positive wherever the DEM is valid, so the weighted average is value*w/w,
# which is the value. Keep a copy of the input to compare the output against.

mkdir -p run
dem_mosaic ../data/dem1_10pct.tif -o run/run
cp ../data/dem1_10pct.tif run/input.tif
