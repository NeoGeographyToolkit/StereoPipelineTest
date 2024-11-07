#!/bin/bash

set -x verbose
rm -rfv run

# Form the position uncertainty file
pos=run/pos.txt
mkdir -p $(dirname $pos)
rm -f pos.txt 
echo ../data/B17_016219_1978_XN_17N282W.8bit.cub 0.5 0.2 >> pos.txt; 
echo ../data/B18_016575_1978_XN_17N282W.8bit.cub  0.5 0.2 >> pos.txt

bundle_adjust                                  \
  --threads 1                                  \
  ../data/B17_016219_1978_XN_17N282W.8bit.cub  \
  ../data/B18_016575_1978_XN_17N282W.8bit.cub  \
  ../data/B17_016219_1978_XN_17N282W.8bit.json \
  ../data/B18_016575_1978_XN_17N282W.8bit.json \
  --match-files-prefix ../data/run             \
  -o run/run

