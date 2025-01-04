#!/bin/bash

set -x verbose
rm -rfv run

stereo                                                             \
  --ortho-heights 2280 2280                                        \
  ../data/left_pleiades_ortho.tif ../data/right_pleiades_ortho.tif \
  ../data/left_pleiades_ortho.xml ../data/right_pleiades_ortho.xml \
  run/run

point2dem --nodata-value -32768 --errorimage --t_srs EPSG:32612 --tr 2.0 run/run-PC.tif       
