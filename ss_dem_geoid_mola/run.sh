#!/bin/bash

set -x verbose
rm -rfv run

dem_geoid ../data/mars.tif -o run/run --double

