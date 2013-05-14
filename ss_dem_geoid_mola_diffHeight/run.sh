#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

# In this example the geoid and the DEM datums have different heights.

dem_geoid $d/mars_3396000m.tif -o run/run --double

