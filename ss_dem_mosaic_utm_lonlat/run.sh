#!/bin/bash

set -x verbose
rm -rfv run

dem_mosaic ../data/clip2_utm.tif ../data/clip1_lonlat.tif -o run/run

dem_mosaic ../data/clip2_utm.tif ../data/clip1_lonlat.tif -o run/run --save-index-map --first


