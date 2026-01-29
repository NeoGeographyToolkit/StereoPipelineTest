#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

stereo_sweep                                      \
  --param-sweep                                   \
    "--stereo-algorithm asp_mgm asp_sgm
    --subpixel-mode 1 9
    --corr-kernel 7,7 9,9"                        \
  ../data/B17_016219_1978_XN_17N282W.8bit.map.tif \
  ../data/B18_016575_1978_XN_17N282W.8bit.map.tif \
  ../data/B17_016219_1978_XN_17N282W.8bit.json    \
  ../data/B18_016575_1978_XN_17N282W.8bit.json    \
  --dem ../data/linescanDEM.tif                   \
  --output-dir run                                \
  --point2dem-params "
    --tr 10
    --orthoimage
    --errorimage"                                 \
  --dry-run 2>&1 | tee run/run.txt
