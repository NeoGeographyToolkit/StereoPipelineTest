#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Bundle adjustment (per sensor) while floating only certain distortion
# coefficients. This also influences --min-distortion.

ls ../data/left_sub16.tif > run/sensor1_images.txt
ls ../data/right_sub16.tif > run/sensor2_images.txt
ls ../data/left_sub16.v2.tsai > run/sensor1_cameras.txt
ls ../data/right_sub16.v2.tsai > run/sensor2_cameras.txt
bundle_adjust --solve-intrinsics                                  \
    --inline-adjustments                                          \
    --intrinsics-to-float "distortion"                            \
    --fixed-distortion-indices 4                                  \
    -t pinhole                                                    \
    --threads 1                                                   \
    --num-iterations 10                                           \
    --image-list run/sensor1_images.txt,run/sensor2_images.txt    \
    --camera-list run/sensor1_cameras.txt,run/sensor2_cameras.txt \
    -o run/run

