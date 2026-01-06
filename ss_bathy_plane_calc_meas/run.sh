#!/bin/bash

set -x verbose
rm -rfv run

bathy_plane_calc --dem ../data/nobathy-DEM.tif --water-height-measurements ../data/bathy_meas.csv --csv-format "2:lon 3:lat 5:height_above_datum" --num-samples 10000 --outlier-threshold 0.5 --bathy-plane run/meas_plane.txt --output-inlier-shapefile run/meas_inliers.shp --dem-minus-plane run/diff.tif

