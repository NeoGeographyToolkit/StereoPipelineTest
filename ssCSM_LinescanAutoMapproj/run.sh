#!/bin/bash

# Test parallel_stereo --mapproject and --point2dem-options together: auto-mapproject
# the raw linescan images onto the DEM, with a common projection, grid size, and
# bounding box, run stereo, then make the DEM in the same call. --point2dem-options
# carries the point2dem flags, with --orthoimage (texture autocompleted from L.tif)
# and --errorimage exercising those paths. The --t_projwin and --tr keep the box
# small and the grid fixed, so the result is reproducible and the test is fast.

set -x verbose
rm -rfv run

parallel_stereo --mapproject --dem ../data/linescanDEM.tif --t_projwin -600 -600 600 600 --tr 10 ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub ../data/B17_016219_1978_XN_17N282W.8bit.json ../data/B18_016575_1978_XN_17N282W.8bit.json run/run --stereo-algorithm asp_mgm --processes 2 --threads-multiprocess 2 --point2dem-options "-r mars --nodata-value -32767 --orthoimage --errorimage"
