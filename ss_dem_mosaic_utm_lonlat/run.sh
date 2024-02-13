#!/bin/bash

set -x verbose
rm -rfv run

# Trying to find bugs with 360 degree offsets

# Go one way
dem_mosaic ../data/clip2_utm.tif ../data/clip1_lonlat.tif -o run/run1

# Go the other way
dem_mosaic ../data/clip1_lonlat.tif ../data/clip2_utm.tif -o run/run2

dem_mosaic ../data/clip2_utm.tif ../data/clip1_lonlat.tif -o run/run --save-index-map --first

