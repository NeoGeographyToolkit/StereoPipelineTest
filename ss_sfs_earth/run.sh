#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Test sfs for earth with sun angles
sfs --threads 8 -i ../data/sfs_earth/tile-129.tif --smoothness-weight 3 --initial-dem-constraint-weight 0.001 --reflectance-type 0 --sun-angles ../data/sfs_earth/sun_angles.txt --image-list ../data/sfs_earth/image_list.txt --camera-list ../data/sfs_earth/camera_list.txt --crop-input-images --save-sparingly --num-haze-coeffs 1 --robust-threshold 10 --float-exposure --float-haze --float-albedo --max-iterations 5 --fix-dem -o run/run --query > run/run.txt
