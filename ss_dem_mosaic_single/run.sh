#!/bin/bash

set -x verbose
rm -rfv run

# Test if mosaicking just one DEM yields the same thing as the input

dem_mosaic ../data/dem1_10pct.tif -o run/run


