#!/bin/bash

set -x verbose
rm -rfv run

# These dems are offset by 360 degrees in longitude and they overlap only partially.
# There were bugfixes in both of these cases.
geodiff ../data/dem_clip7.tif ../data/dem_clip8.tif -o run/run

