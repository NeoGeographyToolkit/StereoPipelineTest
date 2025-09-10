#!/bin/bash

set -x verbose
rm -rfv run

dem_mosaic --gdal-tap --t_projwin 641401.8156284407 4120288.8995428025 652701.8156284407 4133728.8995428025 --tr 16 ../data/clip1_utm.tif -o run/run.tif

