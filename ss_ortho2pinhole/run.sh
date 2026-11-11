#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Recover the pinhole camera extrinsics from a raw frame, its ortho image, and a
# sample camera that carries only the intrinsics (zeroed extrinsics). The ortho
# was made by mapprojecting the known camera onto the WGS84 datum at height 0, so
# the recovered camera must match the known one. The camera is 462.56 m above the
# datum (the geodetic height of the known camera center).
ortho2pinhole                             \
  --camera-height 462.56                  \
  --orthoimage-height 0                   \
  ../data/img_icebridge2.tif              \
  ../data/img_icebridge2_ortho.tif        \
  ../data/img_icebridge2_intrinsics.tsai  \
  run/out.tsai

# Keep run/ to just the camera, so the gold holds only out.tsai.
find run -name 'out.tsai-log-ortho2pinhole-*.txt' -delete
