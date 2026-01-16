#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

# cam_test with bathy plane
cam_test --image ../data/left_bathy_b3_corr.tif --cam1 ../data/left_bathy.xml --cam2 ../data/left_bathy.xml --bathy-plane ../data/bathy-plane.txt --refraction-index 1.333 --height-above-datum -16  | grep -i -v elapsed > run/run.txt

