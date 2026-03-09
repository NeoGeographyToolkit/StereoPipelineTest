#!/bin/bash

# Test DG mapproject with --t_projwin in polar stereographic projection.
# Uses GSD=0.3 with bounds at GSD*(n+0.5) (pixel edges aligned to half-grid).
# This tests that the output extent matches the input --t_projwin exactly,
# even when large coordinate values cause floating-point precision loss in
# the grid snapping logic (floor/ceil of coord/GSD).

set -x verbose
rm -rfv run

opt="+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
mapproject --mpp 0.3 --t_srs "$opt" \
  --t_projwin -1580009.550000 -681020.850000 -1579889.550000 -681155.850000 \
  ../data/krigged_dem_nsidc_ndv0_fill_crop2.tif \
  ../data/WV01_11JAN131652222-P1BS-10200100104A0300.tif \
  ../data/WV01_11JAN131652222-P1BS-10200100104A0300.xml \
  run/run-DG.tif -t dg
