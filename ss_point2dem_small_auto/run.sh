#!/bin/bash

set -x verbose
rm -rfv run

# Test --t_srs auto

opt="--t_srs auto --tr 20 --csv-format 1:lon,2:lat,3:height_above_datum"

point2dem -r earth $opt ../data/small_north.csv -o run/run-north
point2dem -r earth $opt ../data/small_south.csv -o run/run-south
point2dem -r earth $opt ../data/grand_mesa.csv -o run/run-grand-mesa
point2dem -r moon  $opt ../data/moon.csv -o run/run-moon

