#!/bin/bash

set -x verbose
rm -rfv run

# A very basic test of solving for intrinsics per sensor
mkdir -p run

echo ../data/FC21B0004011_11224024300F1E.cub > run/sensor1_images.txt
echo ../data/FC21B0004012_11224030401F1E.cub > run/sensor2_images.txt
echo ../data/FC21B0004011_11224024300F1E.json > run/sensor1_cameras.txt
echo ../data/FC21B0004012_11224030401F1E.json > run/sensor2_cameras.txt

bundle_adjust --solve-intrinsics                                  \
    --inline-adjustments                                          \
    --intrinsics-to-float all                                     \
    --image-list run/sensor1_images.txt,run/sensor2_images.txt    \
    --camera-list run/sensor1_cameras.txt,run/sensor2_cameras.txt \
    --max-pairwise-matches 1000                                   \
    --num-iterations 2                                            \
    --num-passes 1                                                \
    --threads 1                                                   \
    -o run/run
