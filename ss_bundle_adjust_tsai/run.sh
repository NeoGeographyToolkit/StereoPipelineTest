#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

echo "1.2  0    0    2000"  > run/transform.txt
echo "0    1.2  0    3000" >> run/transform.txt
echo "0    0    1.2  4000" >> run/transform.txt
echo "0    0    0       1" >> run/transform.txt

# First do bundle adjustment (per sensor)
ls ../data/left_sub16.tif > run/sensor1_images.txt
ls ../data/right_sub16.tif > run/sensor2_images.txt
ls ../data/left_sub16.v2.tsai > run/sensor1_cameras.txt
ls ../data/right_sub16.v2.tsai > run/sensor2_cameras.txt
bundle_adjust --solve-intrinsics                                  \
    --inline-adjustments                                          \
    --intrinsics-to-float "other_intrinsics"                      \
    -t pinhole                                                    \
    --threads 1                                                   \
    --num-iterations 10                                           \
    --image-list run/sensor1_images.txt,run/sensor2_images.txt    \
    --camera-list run/sensor1_cameras.txt,run/sensor2_cameras.txt \
    ../data/gcp_sub16.gcp                                         \
    --datum WGS84                                                 \
    -o run/ba1/run

# Then just apply a transform
bundle_adjust ../data/left_sub16.tif ../data/right_sub16.tif  run/ba1/run-left_sub16.v2.tsai run/ba1/run-right_sub16.v2.tsai --inline-adjustments -t pinhole --datum WGS84 -o run/run --initial-transform run/transform.txt --apply-initial-transform-only --threads 1
