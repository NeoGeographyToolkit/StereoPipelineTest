#!/bin/bash

set -x verbose
rm -rfv run

stereo -t dg                    \
  --stereo-algorithm asp_mgm    \
  --ortho-heights               \
  -23.1 -23.3                   \
  ../data/left_bathy_ortho.tif  \
  ../data/right_bathy_ortho.tif \
  ../data/left_bathy.xml        \
  ../data/right_bathy.xml       \
  run/run

point2dem run/run-PC.tif
