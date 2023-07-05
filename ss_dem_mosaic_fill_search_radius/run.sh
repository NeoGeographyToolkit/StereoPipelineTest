#!/bin/bash

set -x verbose
rm -rfv run

# Fill with search radius
dem_mosaic --fill-search-radius 50 --fill-percent 10 --fill-num-passes 2 --fill-power 8 ../data/dem_with_nodata.tif -o run/filled.tif

# Blur a little
dem_mosaic --dem-blur-sigma 2 run/filled.tif -o run/blur.tif

