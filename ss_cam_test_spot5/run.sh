#!/bin/bash

# SPOT5 CSM linescan model self-consistency test.
# Same camera compared against itself (both use CSM).

set -x verbose
rm -rfv run

mkdir run

cam_test --session1 spot5 --session2 spot5 \
  --image ../data/spot5_front_crop.bil \
  --cam1 ../data/spot5_front_crop.dim \
  --cam2 ../data/spot5_front_crop.dim \
  --sample-rate 100 \
  | grep -E "Min|Max|Median" > run/run-out.txt
