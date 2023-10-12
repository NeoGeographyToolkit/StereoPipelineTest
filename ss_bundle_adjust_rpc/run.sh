#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust -t rpc --propagate-errors --num-iterations 10      \
  --threads 1                                                    \
  ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif \
  ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.tif \
  ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml \
  ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml \
  -o run/run

