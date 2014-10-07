#!/bin/bash

set -x verbose
rm -rfv run

point2dem --t_srs '+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs ' ../data/utm-PC.tif -o run/run --nodata-value -32767 --tr 1

