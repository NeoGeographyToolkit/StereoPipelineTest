#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Test sfs for earth with sun angles. Here a small clip is used. A larger clip exists in ../data/sfs_earth/tile-129.tif and
# the full dataset is likely archived on Pleiades. Also test albedo, --allow-borderline-data, --low-light-threshold.
parallel_sfs --threads 1 -i ../data/sfs_earth/dem_clip.tif --smoothness-weight 3 --initial-dem-constraint-weight 0.001 --reflectance-type 0 --sun-angles ../data/sfs_earth/sun_angles.txt --image-list ../data/sfs_earth/image_list.txt --camera-list ../data/sfs_earth/camera_list.txt --crop-input-images --num-haze-coeffs 1 --robust-threshold 10 --float-exposure --float-haze --float-albedo --max-iterations 1 -o run/run --tile-size 60 --padding 10 --albedo-constraint-weight 1 --albedo-robust-threshold 0.2 --allow-borderline-data --shadow-threshold 10 --blending-dist 10 --low-light-threshold 30

