#!/bin/bash

set -x verbose
rm -rfv run

# Test a CSV dataset having data crossing the 180 degree meridian

point2dem --t_srs "+proj=stere +lat_0=90 +lat_ts=70 +lon_0=-45 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs" --csv-format '1:lon 2:lat 3:height_above_datum' --tr 1000 ../data/cloud_180deg.csv -o run/run-stere

point2dem --t_srs "+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs" --csv-format '1:lon 2:lat 3:height_above_datum' --tr 1000 ../data/cloud_180deg.csv -o run/run-utm

point2dem --csv-format 1:lon,2:lat,3:height_above_datum ../data/cloud_180deg.csv -o run/run-lonlat --tr 2

