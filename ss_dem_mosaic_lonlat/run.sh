#!/bin/bash

set -x verbose
rm -rfv run

mkdir -p run
echo ../data/dem1_10pct.tif > run/list.txt
echo ../data/dem2_10pct.tif >> run/list.txt

# Test merging
dem_mosaic -l run/list.txt -o run/run --extra-crop-length 200 \
    --t_projwin 123.62 -14.26 133.03 -24.18 --tr 0.01 --tile-size 300 --tile-list "8 13"

# Test erosion and cog
dem_mosaic --erode 1 --cog run/run-tile-08.tif -o run/run-eroded.tif

# Test hole-filling 
dem_mosaic --hole-fill-len 200 run/run-eroded.tif -o run/run-filled.tif

