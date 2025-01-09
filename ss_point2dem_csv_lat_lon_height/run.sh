#!/bin/bash

set -x verbose
rm -rfv run

point2dem -r mars ../data/moc_pc_latlon.csv --tr 10 --nodata-value -32767 --csv-format '1:lat 2:lon 3:height_above_datum' -o run/run

