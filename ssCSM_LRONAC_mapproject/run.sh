#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo \
  ../data/M181058717LE.ce_mapproject.tif \
  ../data/M181073012LE.ce_mapproject.tif \
  ../data/M181058717LE.ce.json           \
  ../data/M181073012LE.ce.json           \
  run/run                                \
  --dem ../data/lro_nac_clip.tif         \
  --stereo-algorithm asp_mgm            \
  --subpixel-mode 9

point2dem --tr 1.2 run/run-PC.tif
