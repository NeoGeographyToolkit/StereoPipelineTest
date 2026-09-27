#!/bin/bash

set -x verbose
rm -rfv run

# In this example the geoid and the DEM datums have different heights.

dem_geoid ../data/mars_3396000m_np.tif -o run/run --double

