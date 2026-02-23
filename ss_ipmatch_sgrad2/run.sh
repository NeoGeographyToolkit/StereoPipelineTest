#!/bin/bash

set -x verbose
rm -rfv run

# Run ipfind with sgrad2 descriptor and ipmatch.
# This exercises SGrad2DescriptorGenerator in IntegralDescriptor.h
# and the IntegralImage.h functions it calls.

method="log"
desc="sgrad2"

ipfind --ip-per-tile 2000 --interest-operator $method \
  --descriptor-generator $desc --threads 1 \
  ../data/left_sub16.tif ../data/right_sub16.tif \
  --output-folder run

ipmatch --distance-metric l2 --ransac-constraint none --threads 1 \
  ../data/left_sub16.tif run/left_sub16.vwip \
  ../data/right_sub16.tif run/right_sub16.vwip \
  -o run/run
