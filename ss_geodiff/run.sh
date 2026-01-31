#!/bin/bash

set -x verbose
rm -rfv run

# Test --cog
geodiff --cog ../data/dem1_10pct.tif ../data/dem2_10pct.tif -o run/run-lonlat

geodiff ../data/clip2_utm.tif ../data/clip1_lonlat.tif -o run/run-utm-lonat

