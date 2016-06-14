#!/bin/bash

set -x verbose
rm -rfv run

# To do: When the clips are interchanged, the results are wrong!

dem_mosaic ../data/clip1_lonlat.tif ../data/clip2_utm.tif -o run/run --use-centerline-weights


