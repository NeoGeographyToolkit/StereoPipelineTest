#!/bin/bash

set -x verbose
rm -rfv run

point2dem --t_srs '+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs ' ../data/utm-PC.tif -o run/run --nodata-value -32767 --tr 1

point2dem --t_srs '+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs ' ../data/utm-PC.tif -o run/run --nodata-value -32767 --tr 1 --filter min

point2dem --t_srs '+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs ' ../data/utm-PC.tif -o run/run --nodata-value -32767 --tr 1 --filter max

point2dem --t_srs '+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs ' ../data/utm-PC.tif -o run/run --nodata-value -32767 --tr 1 --filter mean

point2dem --t_srs '+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs ' ../data/utm-PC.tif -o run/run --nodata-value -32767 --tr 1 --filter median

point2dem --t_srs '+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs ' ../data/utm-PC.tif -o run/run --nodata-value -32767 --tr 1 --filter stddev

point2dem --t_srs '+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs ' ../data/utm-PC.tif -o run/run --nodata-value -32767 --tr 1 --filter count

point2dem --t_srs '+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs ' ../data/utm-PC.tif -o run/run --nodata-value -32767 --tr 1 --filter nmad

point2dem --t_srs '+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs ' ../data/utm-PC.tif -o run/run --nodata-value -32767 --tr 1 --filter 50-pct

point2dem --t_srs '+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs ' ../data/utm-PC.tif -o run/run --nodata-value -32767 --tr 1 --filter 50.1-pct

