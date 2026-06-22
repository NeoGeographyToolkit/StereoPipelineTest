#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Bundle adjustment of a CaSSIS framelet stereo pair whose file names are long
# enough to exercise the shortening of match file names (see the ASP doc section
# on match file naming). The match files end up with the full, untruncated image
# names. This is a regression test for that behavior.

L=../data/cas_cal_sc_20210725T202821-20210725T202825-16378-10-PAN-838849161-8-0__4_0
R=../data/cas_cal_sc_20210725T202911-20210725T202915-16378-10-PAN-838849162-2-0__4_0

bundle_adjust $L.cub $R.cub $L.json $R.json \
  -t csm                                    \
  -o run/run                                \
  --threads 1                               \
  --ip-per-image 20000                      \
  --min-matches 1                           \
  --camera-weight 0
