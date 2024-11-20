#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/M0100115_crop.map.cub ../data/E0201461_crop.map.cub run/run --alignment-method none

point2dem -r mars run/run-PC.tif --nodata-value -32767 --errorimage  


