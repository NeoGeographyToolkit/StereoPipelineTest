#!/bin/bash

set -x verbose
rm -rfv run

point2dem -r mars ../data/moc_pc_xyz.csv --tr 10 --nodata-value -32767 --csv-format '1:x 2:y 3:z' -o run/run --search-radius-factor 2 --cog

