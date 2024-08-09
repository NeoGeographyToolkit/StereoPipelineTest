#!/bin/bash

set -x verbose
rm -rfv run

# Test using images mapprojected with the dg session but now running with json cameras.
# This requires loading the dg cameras to undo the mapprojection.
# Test running stereo with no default file.
# Test --corr-seed-mode 2 with mapprojected images.

stereo --corr-seed-mode 2                                \
  --disparity-estimation-dem ../data/grand_mesa_clip.tif \
  --disparity-estimation-dem-error 5                     \
  ../data/grand_mesa_WV03_left.map.dg.tif                \
  ../data/grand_mesa_WV03_right.map.dg.tif               \
  ../data/grand_mesa_WV03_left.json                      \
  ../data/grand_mesa_WV03_right.json                     \
  run/run                                                \
  ../data/grand_mesa_clip.tif
point2dem run/run-PC.tif

