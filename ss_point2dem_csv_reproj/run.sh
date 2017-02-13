#!/bin/bash

set -x verbose
rm -rfv run

# Reproject from lon, lat, height to northing, easting, height. This is a bugfix.

point2dem --t_srs "+proj=stere +lat_0=90 +lat_ts=70 +lon_0=-45 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs" --csv-format '1:lon 2:lat 3:height_above_datum' --tr 0.4 ../data/icebridge_cloud.csv -o run/run



