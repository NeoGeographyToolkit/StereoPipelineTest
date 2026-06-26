#!/bin/bash

# Standalone sparse_disp runs that produce sub-pixel matches on a uniform grid
# from a pair of already-mapprojected images. This exercises --subpixel-mode,
# --save-match-file, and both --uncertainty-mode values (1 = sharpness,
# 2 = Cramer-Rao). The matches are written as plain text (--matches-as-txt), so
# the per-match sigma is human-readable and easy to validate. The CTX (Mars)
# B17/B18 mapprojected pair is reused from the linescan tests. It is well
# textured, so the correlation locks onto real terrain. The two text match files
# (one per uncertainty mode) are the products that are validated.

set -x verbose
rm -rfv run

for mode in 1 2; do
  sparse_disp \
    ../data/B17_016219_1978_XN_17N282W.8bit.map.crop.tif \
    ../data/B18_016575_1978_XN_17N282W.8bit.map.crop.tif \
    run/m${mode} \
    --coarse 60 --fine 60 \
    --xsearch 80 --ysearch 80 \
    --subpixel-mode 1 \
    --uncertainty-mode ${mode} \
    --save-match-file \
    --matches-as-txt \
    --nodata-value 0 \
    --processes 4
done
