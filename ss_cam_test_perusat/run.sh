#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

# PeruSat exact linescan model: old VW-based vs new CSM-based.
# Same camera compared against itself. Uses a small crop.

cam_test --session1 perusat --session2 perusat \
  --image ../data/IMG_PER1_20171207153639_SEN_P_000041_crop.tif \
  --cam1 ../data/DIM_PER1_20171207153639_SEN_P_000041.XML \
  --cam2 ../data/DIM_PER1_20171207153639_SEN_P_000041.XML \
  --perusat-vs-csm \
  --sample-rate 100 \
  | grep -E "Min|Max|Median" > run/run-out.txt
