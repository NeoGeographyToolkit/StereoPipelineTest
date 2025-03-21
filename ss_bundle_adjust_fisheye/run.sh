#!/bin/bash

set -x verbose
rm -rfv run

# Test fisheye lens distortion
bundle_adjust ../data/DMS_20171029_183704_02500.tif ../data/DMS_20171029_183706_02501.tif ../data/DMS_20171029_183704_02500.fisheye.tsai ../data/DMS_20171029_183706_02501.fisheye.tsai -o run/run --ip-per-tile 200 --num-passes 2 --remove-outliers-params "75 3 1 2" --threads 1 --max-pairwise-matches 15000 --num-iterations 10

