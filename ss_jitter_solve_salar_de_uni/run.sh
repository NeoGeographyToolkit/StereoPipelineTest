#!/bin/bash

set -x verbose
rm -rfv run

# This tests the smoothness weight constraint in a realistic setting.
# Very useful for making changes to this logic. See also the dataset:
# ss_jitter_solve_synthetic.

# Normally one should double max-pairwise-matches, do two passes, and 10 iterations.

jitter_solve ../data/104001001427B900.r100.tif ../data/1040010014761800.r100.tif ../data/csm-104001001427B900.r100.adjusted_state.json ../data/csm-1040010014761800.r100.adjusted_state.json --match-files-prefix ../data/dense_match/run --num-lines-per-position 200 --num-lines-per-orientation 200 --num-iterations 5 --num-passes 1 --max-pairwise-matches 10000 --max-initial-reprojection-error 100 --robust-threshold 0.5 --tri-weight 0.05 --tri-robust-threshold 0.05 --num-anchor-points 10000 --num-anchor-points-extra-lines 5000 --anchor-dem ../data/salar_case2_refdem_proj-adj-0.91m.tif --anchor-weight 0.05 --heights-from-dem ../data/ICESat2aligned2WV-trans_source-DEM.tif --heights-from-dem-uncertainty 2 --threads 1 --camera-position-weight 10000 --smoothness-weight 1 -o run/run

pref1=../data/csm-104
pref2=run/run-csm-104
suff=001001427B900.r100,0010014761800.r100
~/miniconda3/envs/orbit_plot/bin/python \
  $(which orbit_plot.py)                \
  --subtract-line-fit                   \
  --dataset $pref1,$pref2               \
  --orbit-id $suff                      \
  --output-file run/run.png             \
  --dataset-label before,after

