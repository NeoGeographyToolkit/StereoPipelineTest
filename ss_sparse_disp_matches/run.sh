#!/bin/bash

# Standalone sparse_disp run that produces sub-pixel matches on a uniform grid
# from a pair of already-mapprojected orthoimages. This exercises the
# --subpixel-mode and --save-match-file options. The match file is the product
# that is validated. The WV01 ortho pair is reused from the seedMode3 test.

set -x verbose
rm -rfv run

sparse_disp \
  ../data/WV01_11JAN131652222-P1BS-10200100104A0300_ortho1.0m_sub2_crop2.tif \
  ../data/WV01_11JAN131653180-P1BS-1020010011862E00_ortho1.0m_sub2_crop2.tif \
  run/run \
  --coarse 80 --fine 80 \
  --xsearch 60 --ysearch 60 \
  --subpixel-mode 1 \
  --save-match-file \
  --nodata-value 0 \
  --processes 4
