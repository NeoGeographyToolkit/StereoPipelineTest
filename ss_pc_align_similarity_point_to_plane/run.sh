#!/bin/bash

set -x verbose
rm -rfv run

# The file ../data/dem_clip13_trans.tif was made from ../data/dem_clip13.tif 
# by applying the inverse of the transform
#
#  1.00001   0.00001 0       50
# -0.00001   1.00001 0       60
#  0         0       1.00001 70
#  0         0       0       1
#
# Trying to recover it using --alignment-method similarity-point-to-plane

pc_align --max-displacement 200 ../data/dem_clip13.tif ../data/dem_clip13_trans.tif -o run/run --alignment-method similarity-point-to-plane --save-transformed-source-points --save-inv-transformed-reference-points 

