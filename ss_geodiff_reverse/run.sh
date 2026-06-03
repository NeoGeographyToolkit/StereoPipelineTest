#!/bin/bash

set -x verbose
rm -rfv run

# Default diff (dem1 - dem2) on the grid of the first DEM.
geodiff ../data/dem1_10pct.tif ../data/dem2_10pct.tif -o run/run-fwd

# Same inputs, but with --reverse the output becomes (dem2 - dem1) on the
# same grid. The reversed result must be the negative of the default one.
geodiff --reverse ../data/dem1_10pct.tif ../data/dem2_10pct.tif -o run/run-rev
