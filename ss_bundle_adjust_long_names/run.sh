#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Regression test for the shortening of long interest point match file names
# (see the ASP doc section on match file naming).
#
# The two input images are a real CaSSIS framelet stereo pair, but their file
# names have been artificially lengthened (the repeated "_pad" in the middle) so
# that the produced match file name exceeds what a file system allows for a
# single file name. The two names also share a long common prefix, so a naive
# fixed-length truncation would map them to the same string. The name shortening
# logic must instead reduce each name to a leading part plus a hash of the full
# name, keeping the pair distinct. The produced match file names below carry
# those hashes.

L=../data/cas_cal_sc_20210725_16378_PAN_synthetic_test_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_LEFT_838849161_8_0
R=../data/cas_cal_sc_20210725_16378_PAN_synthetic_test_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_RIGHT_838849162_2_0

bundle_adjust $L.cub $R.cub $L.json $R.json \
  -t csm                                        \
  -o run/run                                    \
  --threads 1                                   \
  --ip-per-image 20000                          \
  --min-matches 1                               \
  --camera-weight 0
