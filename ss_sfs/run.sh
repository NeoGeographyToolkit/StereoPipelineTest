#!/bin/bash

set -x verbose
rm -rfv run

# SfS without approximating the camera model or input adjustments
sfs -i ../data/sfs-input-DEM.tif ../data/sfs-cam.cub -o run/run --max-iterations 2 --crop-input-images --threads 1

