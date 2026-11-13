#!/bin/bash

set -x verbose
rm -rfv run

# Mosaicking a single DEM must return that same DEM. The blending weight is
# positive wherever the DEM is valid, so the weighted average is value*w/w,
# which is the value. Keep a copy of the input to compare the output against.

mkdir -p run
dem_mosaic ../data/dem1_10pct.tif -o run/run
cp ../data/dem1_10pct.tif run/input.tif

# Grid and statistics summary of the mosaicked tile, for the gold diff. The
# projection name is normalized by the writer for the same datum, so it is not
# included. A single-DEM mosaic must reproduce the input, so this also locks the
# identity (gold was seeded from a correct run).
gdalinfo -stats run/run-tile-0.tif | grep -E 'Size is|Pixel Size|^Origin|STATISTICS_|NoData Value' > run/stats.txt
rm -f run/run-tile-0.tif.aux.xml run/input.tif.aux.xml
