#!/bin/bash

set -x verbose
rm -rfv run

dem_geoid ../data/mars_np.tif -o run/run --double

