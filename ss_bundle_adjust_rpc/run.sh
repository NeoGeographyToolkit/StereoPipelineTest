#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust -t rpc --propagate-errors --num-iterations 10      \
  --threads 1                                                    \
  --save-adjusted-rpc                                            \
  ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif \
  ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.tif \
  ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml \
  ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml \
  -o run/run

# Sanity check with cam_test
for f in \
  09OCT11191503-P1BS_R1C1-052783426010_01_P001 \
  09OCT11191555-P1BS_R1C1-052783426010_01_P001; do
  
  cam_test                                  \
  --session1 rpc                            \
  --session2 rpc                            \
  --image ../data/${f}_sub10.tif            \
  --cam1 ../data/${f}_sub10.xml             \
  --cam2 run/run-${f}_sub10.adjusted_rpc.xml\
  --cam1-bundle-adjust-prefix run/run       \
  --cam2-bundle-adjust-prefix ""

done
