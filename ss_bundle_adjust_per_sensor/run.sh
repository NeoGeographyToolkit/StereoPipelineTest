#!/bin/bash

set -x verbose
rm -rfv run

# Solve for intrinsics per sensor. This is a very basic run only meant
# to go through the motions. See the doc for more details.

mkdir -p run

ls ../data/kaguya/TC1W2B0_01_02934N034E0959.cub \
   ../data/kaguya/TC1W2B0_01_02935N034E0949.cub > run/tc1_images.txt
ls ../data/kaguya/TC2W2B0_01_02934N036E0959.cub \
   ../data/kaguya/TC2W2B0_01_02935N036E0949.cub > run/tc2_images.txt

ls ../data/kaguya/TC1W2B0_01_02934N034E0959.json \
   ../data/kaguya/TC1W2B0_01_02935N034E0949.json > run/tc1_cameras.txt
ls ../data/kaguya/TC2W2B0_01_02934N036E0959.json \
   ../data/kaguya/TC2W2B0_01_02935N036E0949.json > run/tc2_cameras.txt              

bundle_adjust --solve-intrinsics                          \
    --inline-adjustments                                  \
    --intrinsics-to-float all                             \
    --image-list run/tc1_images.txt,run/tc2_images.txt    \
    --camera-list run/tc1_cameras.txt,run/tc2_cameras.txt \
    --match-files-prefix ../data/kaguya/ba/run            \
    --max-pairwise-matches 1000                           \
    --num-iterations 2                                    \
    --num-passes 1                                        \
    --threads 1                                           \
    -o run/run
