#!/bin/bash

set -x verbose
rm -rfv run

# This tests creating a DEM from a very small CSV file with all heights being equal
proj="+proj=stere +lat_0=0 +lat_ts=0 +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=1737400 +b=1737400 +units=m +no_defs"

point2dem --stereographic                                \
  --proj-lon 0 --proj-lat 0 -r moon                      \
  --csv-format 1:northing,2:easting,3:height_above_datum \
  --csv-proj4  "$proj"                                   \
  --tr 1.0                                               \
  ../data/small.csv -o run/run

