#!/bin/bash

set -x verbose
rm -rfv run

# SfS with saving of variances
sfs -i ../data/sfs-input-DEM.tif ../data/sfs-cam.cub --max-iterations 2 --crop-input-images --threads 1 --allow-borderline-data --blending-dist 5 --shadow-threshold 0.026 -o run/run --save-variances

