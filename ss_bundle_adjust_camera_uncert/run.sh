#!/bin/bash

set -x verbose
rm -rfv run

# Form the position uncertainty file
wt=0.1
pos=run/pos.txt
mkdir -p $(dirname $pos)
rm -f $pos
echo ../data/B17_016219_1978_XN_17N282W.8bit.cub $wt $wt >> $pos
echo ../data/B18_016575_1978_XN_17N282W.8bit.cub $wt $wt >> $pos

bundle_adjust                                  \
  --threads 1                                  \
  --num-passes 1                               \
  --num-iterations 10                          \
  --camera-position-uncertainty $pos           \
  ../data/B17_016219_1978_XN_17N282W.8bit.cub  \
  ../data/B18_016575_1978_XN_17N282W.8bit.cub  \
  ../data/B17_016219_1978_XN_17N282W.8bit.json \
  ../data/B18_016575_1978_XN_17N282W.8bit.json \
  --match-files-prefix ../data/run             \
  -o run/ba

jitter_solve                                   \
  --camera-position-uncertainty $pos           \
  --smoothness-weight 1                        \
  --threads 1                                  \
  --num-passes 1                               \
  --num-iterations 10                          \
  --match-files-prefix ../data/run             \
  --max-pairwise-matches 20000                 \
  ../data/B17_016219_1978_XN_17N282W.8bit.cub  \
  ../data/B18_016575_1978_XN_17N282W.8bit.cub  \
  ../data/B17_016219_1978_XN_17N282W.8bit.json \
  ../data/B18_016575_1978_XN_17N282W.8bit.json \
  -o run/jitter

