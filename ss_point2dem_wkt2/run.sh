#!/bin/bash

set -x verbose
rm -rfv run

# This testcase reproduces a bug with dynamic CRS and multipl threads

point2dem --tr 1.0 --t_srs ../data/proj.wkt --nodata-value -9999.0 ../data/cloud.tif -o run/run
