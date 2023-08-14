#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust                                                    \
  ../data/BSG-102-20220425-215106-22900060_georeferenced-pan.tif \
  ../data/BSG-102-20220425-215147-22900061_georeferenced-pan.tif \
  --ip-per-tile 300 --matches-per-tile 100                       \
  --threads 1                                                    \
  -o run/run

