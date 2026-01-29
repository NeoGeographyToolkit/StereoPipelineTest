#!/bin/bash

# Test parallel_stereo with mapprojected images and --num-matches-from-disp-triplets

stereo_sweep                                      \
  ../data/B17_016219_1978_XN_17N282W.8bit.map.tif \
  ../data/B18_016575_1978_XN_17N282W.8bit.map.tif \
  ../data/B17_016219_1978_XN_17N282W.8bit.json    \
  ../data/B18_016575_1978_XN_17N282W.8bit.json    \
  --dem ../data/linescanDEM.tif                   \
  --output-dir run                                \
  --point2dem-params '--tr 10 --orthoimage --errorimage'

