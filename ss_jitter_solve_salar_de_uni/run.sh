#!/bin/bash

set -x verbose
rm -rfv run

# This tests the smoothness weight constraint in a realistic setting.
# Very useful for making changes to this logic. See also the dataset:
# ss_jitter_solve_synthetic.

# Normally one should double --max-pairwise-matches 20000 --num-anchor-points 20000, do two passes, and 10 iterations.

# The images are the top-left 10000 x 10000 crops (jitter_solve uses only their
# size). Use the native 400 lines per pose. With the position uncertainty and
# smoothness below all steps are accepted and cameras move about 1 m.
jitter_solve --matches-as-txt ../data/104001001427B900.r100.tif ../data/1040010014761800.r100.tif ../data/csm-104001001427B900.r100.adjusted_state.json ../data/csm-1040010014761800.r100.adjusted_state.json --match-files-prefix ../data/dense_match/run --num-lines-per-position 400 --num-lines-per-orientation 400 --num-iterations 5 --num-passes 1 --max-pairwise-matches 3000 --max-initial-reprojection-error 100 --robust-threshold 0.5 --tri-weight 0.05 --tri-robust-threshold 0.05 --num-anchor-points 1000 --num-anchor-points-extra-lines 5000 --anchor-dem ../data/salar_case2_refdem_proj-adj-0.91m.tif --anchor-weight 0.05 --heights-from-dem ../data/ICESat2aligned2WV-trans_source-DEM.tif --heights-from-dem-uncertainty 2 --threads 1 --camera-position-uncertainty 0.1,0.1 --camera-position-uncertainty-power 4 --smoothness-weight 10 -o run/run

exit 0

# For some reason orbit_plot.py is slow. Turning off for now.
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

