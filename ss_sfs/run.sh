#!/bin/bash

set -x verbose
rm -rfv run

# SfS without approximating the camera model or input adjustments. Test the option --allow-borderline-data
sfs -i ../data/sfs-input-DEM.tif ../data/sfs-cam.cub -o run/run --max-iterations 2 --crop-input-images --threads 1 --allow-borderline-data --blending-dist 5 --shadow-threshold 0.026

# Estimate height errors
sfs -i ../data/sfs-input-DEM.tif ../data/sfs-cam.cub -o run/run --max-iterations 2 --crop-input-images --threads 1 --estimate-height-errors

