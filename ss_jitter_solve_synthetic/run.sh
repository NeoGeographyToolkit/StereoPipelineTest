#!/bin/bash

set -x verbose
rm -rfv run

# This tests the smoothness weight constraint with synthetic data
# Very useful for making changes to this logic. See also the dataset:
# ss_jitter_solve_salar_de_uni

dem=../data/run-DEM_sub4_fill4_sub4.tif
camDir=sim_hirise_jitter2.0
jitterDir=run
/usr/bin/time                          \
jitter_solve                           \
  --smoothness-weight 1                \
  --threads 1                          \
  --camera-position-weight 1e+4        \
  --max-pairwise-matches 20000         \
  --match-files-prefix ../data/run     \
  --num-iterations 10                  \
  --num-passes 1                       \
  --heights-from-dem $dem              \
  --heights-from-dem-uncertainty 10    \
  --num-anchor-points-per-tile 50      \
  --num-anchor-points-extra-lines 1000 \
  --anchor-weight 0.1                  \
  --anchor-dem $dem                    \
  ../data/linescan-nadir-c1.tif        \
  ../data/linescan-fwd-c1.tif          \
  ../data/linescan-nadir-c1.json       \
  ../data/linescan-fwd-c1.json         \
  -o run/run

# plot
pref1=../data/linescan
pref2=run/run-linescan
suff=nadir-c1,fwd-c1
~/miniconda3/envs/orbit_plot/bin/python \
  $(which orbit_plot.py)                \
  --dataset $pref1,$pref2               \
  --use-ref-cams                        \
  --subtract-line-fit                   \
  --orbit-id $suff                      \
  --output-file run/run.png             \
  --dataset-label before,after

