#!/bin/bash

set -x verbose
rm -rfv run

dem_mosaic --priority-blending-length 20 ../data/fine-DEM.tif ../data/coarse-DEM.tif -o run/run      

