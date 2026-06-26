#!/bin/bash

# Standalone sparse_disp run that produces sub-pixel matches on a uniform grid
# from a pair of already-mapprojected images. This exercises the --subpixel-mode
# and --save-match-file options. The match file is the product that is validated.
# The CTX (Mars) B17/B18 mapprojected pair is reused from the linescan tests. It
# is well textured, so the correlation locks onto real terrain.

set -x verbose
rm -rfv run

sparse_disp \
  ../data/B17_016219_1978_XN_17N282W.8bit.map.crop.tif \
  ../data/B18_016575_1978_XN_17N282W.8bit.map.crop.tif \
  run/run \
  --coarse 60 --fine 60 \
  --xsearch 80 --ysearch 80 \
  --subpixel-mode 1 \
  --save-match-file \
  --nodata-value 0 \
  --processes 4
