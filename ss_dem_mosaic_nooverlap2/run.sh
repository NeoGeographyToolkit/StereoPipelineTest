#!/bin/bash

set -x verbose
rm -rfv run

dem_mosaic ../data/dem_clip9.tif ../data/dem_clip10.tif -o run/run

