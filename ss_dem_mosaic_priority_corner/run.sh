#!/bin/bash

set -x verbose
rm -rfv run

# Priority blending at an image corner. Two constant-value DEMs share the same
# top-left corner: a small 150x150 priority (first) square and a bigger 300x300
# square extending beyond it. The small DEM must keep full weight in the corner
# and along its two image-boundary edges (top, left), and blend only toward its
# two internal edges (right, bottom) where the big DEM continues. The weight of
# the small DEM is saved and checked. Only the weight matters, not the heights.

mkdir -p run

gdal_create -outsize 150 150 -bands 1 -burn 1000 -ot Float32 -a_srs EPSG:32610 -a_ullr 500000 4000000 500150 3999850 run/small.tif
gdal_create -outsize 300 300 -bands 1 -burn 2000 -ot Float32 -a_srs EPSG:32610 -a_ullr 500000 4000000 500300 3999700 run/big.tif

dem_mosaic run/small.tif run/big.tif --priority-blending-length 30 -o run/run --save-dem-weight 0
