#!/bin/bash

set -x verbose
rm -rfv run

dem_geoid ../data/earth_np.tif -o run/run --double --geoid egm2008

