#!/bin/bash

set -x verbose
rm -rfv run

# Testing parallel_bundle_adjust with --mapprojected-data
parallel_bundle_adjust --camera-weight 1000 --threads 1 ../data/AS15-M-0760.lev1_crop.cub ../data/AS15-M-0759.lev1_crop.cub -o run/run --mapprojected-data "../data/AS15-M-0760.lev1_crop.map.tif ../data/AS15-M-0759.lev1_crop.map.tif ../data/AS15-M-0760-AS15-M-0759-DEM.tif"
