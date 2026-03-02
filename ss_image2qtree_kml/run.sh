#!/bin/bash

set -x verbose
rm -rfv run

image2qtree ../data/basalt_dem_crop.tif -m kml -o run/kml_out
