#!/bin/bash

set -x verbose
rm -rfv run

point2dem -r Earth ../data/zone10-CA_SanLuisResevoir-9m_10pct-utm.csv --tr .0009765625000000 -o run/run --nodata-value -32767 --csv-format 'utm:10N 1:easting 2:northing 3:height_above_datum'

