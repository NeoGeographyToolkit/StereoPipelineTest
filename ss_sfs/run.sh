#!/bin/bash

set -x verbose
rm -rfv run

# SfS without approximating the camera model or input adjustments. Test the options
# --allow-borderline-data and --curvature-in-shadow.
sfs                                \
  -i ../data/sfs-input-DEM.tif     \
  ../data/sfs-cam.cub              \
  --max-iterations 2               \
  --crop-input-images              \
  --threads 1                      \
  --allow-borderline-data          \
  --blending-dist 5                \
  --shadow-threshold 0.026         \
  --curvature-in-shadow 0.15       \
  --curvature-in-shadow-weight 0.1 \
  --lit-curvature-dist 10          \
  --shadow-curvature-dist 5        \
  -o run/run

# Estimate height errors
sfs                            \
  -i ../data/sfs-input-DEM.tif \
  ../data/sfs-cam.cub          \
  --max-iterations 2           \
  --crop-input-images          \
  --threads 1                  \
  --estimate-height-errors     \
  -o run/run

