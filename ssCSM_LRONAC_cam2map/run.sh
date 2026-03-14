#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo \
  ../data/M181058717LE.ce_cam2map.cub    \
  ../data/M181073012LE.ce_cam2map.cub    \
  ../data/M181058717LE.ce.cub            \
  ../data/M181073012LE.ce.cub            \
  run/run                                \
  --dem ../data/lro_nac_clip.tif         \
  --stereo-algorithm asp_mgm            \
  --subpixel-mode 9

point2dem --tr 1.2 run/run-PC.tif
