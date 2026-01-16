#!/bin/bash

set -x verbose
rm -rfv run

mkdir -p run

# Create the mask list file
echo ../data/left_bathy_b7_mask2.tif ../data/right_bathy_b7_mask2.tif > run/mask_list.txt  

# Bundle adjustment with bathy masks
bundle_adjust                           \
  ../data/left_bathy_b3_corr.tif        \
  ../data/right_bathy_b3_corr.tif       \
  ../data/left_bathy.xml                \
  ../data/right_bathy.xml               \
  --bathy-mask-list run/mask_list.txt   \
  --refraction-index 1.333              \
  --bathy-plane ../data/bathy-plane.txt \
  --threads 1                           \
  -o run/run

