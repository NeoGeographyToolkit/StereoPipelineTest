#!/bin/bash

# SPOT5 CSM linescan model self-consistency test.
# Compares old VW-based model (cam1) against new CSM model (cam2).
# Uses --spot5-vs-csm which loads cam1 as old, cam2 as CSM.
# When --spot5-use-csm is removed, update this to use --session1 spot5
# for both, and drop --spot5-vs-csm.

set -x verbose
rm -rfv run

mkdir run

cam_test --spot5-vs-csm \
  --image ../data/spot5_front_crop.bil \
  --cam1 ../data/spot5_front_crop.dim \
  --cam2 ../data/spot5_front_crop.dim \
  --session1 spot5 --session2 spot5 \
  --sample-rate 100 \
  | grep -E "Min|Max|Median" > run/run-out.txt
