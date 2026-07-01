#!/bin/bash

# Standalone sparse_disp runs producing sub-pixel matches with per-match
# uncertainty from a cross-modal desert pair: airborne lidar intensity (the
# reference) versus NAIP optical imagery (the source), co-registered on the same
# grid. This exercises --subpixel-mode, --save-match-file, --matches-as-txt, and
# all four --metric values (parabola_curvature, cramer_rao, peak_ratio, snr). The
# cross-modal desert case is the relevant one for geolocation assessment, and
# sparse_disp handles the modality gap with its built-in LoG prefilter. The four
# text match files, one per metric, are the products that are validated.

set -x verbose
rm -rfv run

for mode in parabola_curvature cramer_rao peak_ratio snr; do
  sparse_disp \
    ../data/AZ_desert_lidar.tif \
    ../data/AZ_desert_naip.tif \
    run/m_${mode} \
    --coarse 60 --fine 60 \
    --xsearch 80 --ysearch 80 \
    --subpixel-mode 1 \
    --metric ${mode} \
    --save-match-file \
    --matches-as-txt \
    --nodata-value 0 \
    --processes 4
done
