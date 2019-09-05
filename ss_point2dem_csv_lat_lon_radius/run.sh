#!/bin/bash

set -x verbose
rm -rfv run

point2dem -r mars --tr .0000976562500000 ../data/moc_pc_lon_lat_radius.csv --csv-format '1:lon 2:lat 3:radius_m' -o run/run


