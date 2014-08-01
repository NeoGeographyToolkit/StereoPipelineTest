#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/AS15-M-1133.lev1.cub ../data/AS15-M-1134.lev1.cub ../data/AS15-M-1135.lev1.cub run/run
point2dem -r moon run/run-PC.tif --nodata-value -32767 --errorimage

