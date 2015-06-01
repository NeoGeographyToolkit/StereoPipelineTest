#!/bin/bash

set -x verbose
rm -rfv run

point2dem -r Earth ../data/zone10-CA_SanLuisResevoir-9m_10pct-utm.csv --tr .0009765625000000 -o run/run --nodata-value -32767 --csv-format '1:easting 2:northing 3:height_above_datum' --csv-proj4 '+proj=utm +zone=10 +datum=WGS84 +units=m +no_defs'


