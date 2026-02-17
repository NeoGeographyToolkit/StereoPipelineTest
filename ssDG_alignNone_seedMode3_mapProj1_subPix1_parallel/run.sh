#!/bin/bash

set -x verbose
rm -rfv run

sparseOpts='--processes 19 --coarse 512 --fine 256 --output_dec_scale=8'

stereo_dist                                                                  \
  --tile-size 512                                                            \
  --tile-padding 128                                                         \
  --processes 8                                                              \
  --threads-multiprocess 1                                                   \
  -s stereo.default                                                          \
  -t dg                                                                      \
  --alignment-method none                                                    \
  --corr-seed-mode 3                                                         \
  --corr-search -30 -30 30 30                                                \
  --corr-max-levels 5                                                        \
  --corr-tile-size 512                                                       \
  --subpixel-mode 1                                                          \
  --disable-fill-holes                                                       \
  --allow-different-mapproject-gsd                                           \
  --sparse-disp-options "$sparseOpts"                                        \
  ../data/WV01_11JAN131652222-P1BS-10200100104A0300_ortho1.0m_sub2_crop2.tif \
  ../data/WV01_11JAN131653180-P1BS-1020010011862E00_ortho1.0m_sub2_crop2.tif \
  ../data/WV01_11JAN131652222-P1BS-10200100104A0300.xml                      \
  ../data/WV01_11JAN131653180-P1BS-1020010011862E00.xml                      \
  run/run                                                                    \
  --dem ../data/krigged_dem_nsidc_ndv0_fill.tif                              \
  --point2dem-options '--tr 2'

