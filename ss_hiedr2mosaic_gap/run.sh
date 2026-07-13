#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Omit RED4 to create a CCD gap. A missing CCD leaves no hijitreg entry for its
# pair, which used to crash the mosaic step with a KeyError. See issue 491.
hiedr2mosaic.py --dry-run \
  ../data/ESP_029421_2300_RED0_*IMG \
  ../data/ESP_029421_2300_RED1_*IMG \
  ../data/ESP_029421_2300_RED2_*IMG \
  ../data/ESP_029421_2300_RED3_*IMG \
  ../data/ESP_029421_2300_RED5_*IMG \
  ../data/ESP_029421_2300_RED6_*IMG \
  ../data/ESP_029421_2300_RED7_*IMG \
  ../data/ESP_029421_2300_RED8_*IMG \
  > run/output.txt 2>&1
