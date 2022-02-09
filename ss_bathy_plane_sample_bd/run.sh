#!/bin/bash

set -x verbose
rm -rfv run

bathy_plane_calc --dem ../data/nobathy-DEM.tif --mask ../data/left_bathy_b7_mask.tif --camera ../data/left_bathy.xml --num-samples 100 --mask-boundary-shapefile run/run-sample.shp

