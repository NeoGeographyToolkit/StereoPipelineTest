#!/bin/bash

set -x verbose
rm -rfv run


dem_mosaic ../data/dem_clip11.tif ../data/dem_clip12.tif -o run/run --save-dem-weight 0
dem_mosaic ../data/dem_clip11.tif ../data/dem_clip12.tif -o run/run --save-dem-weight 1


