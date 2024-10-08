#!/bin/bash

set -x verbose
rm -rfv run

point2dem -r Earth ../data/zone10-CA_SanLuisResevoir-9m_10pct-utm.csv --tr 10 -o run/run --nodata-value -32767 --csv-format '1:easting 2:northing 3:height_above_datum' --csv-srs '+proj=utm +zone=10 +datum=WGS84 +units=m +no_defs' --t_projwin 641505.000 4133315.000 651505.000 4123315.000

