#!/bin/bash

set -x verbose
rm -rfv run

# Bundle adjustment with optical bar cameras. This has fake images and cameras, just enough to go through the motions
bundle_adjust ../data/DS1105-2248DA079.tif ../data/DS1105-2248DA079_crop.tif ../data/DS1105-2248DA079.tsai ../data/DS1105-2248DA079_crop.tsai -o run/run --solve-intrinsics --num-iterations 3 --num-passes 1 --inline-adjustments --max-pairwise-matches 100 --thread 1

