#!/bin/bash

set -x verbose
rm -rfv run

# Optimize distortion only for some cameras. For those, test option --min-distortion with the default value
mkdir -p run
ls ../data/left_sub16.tif > run/sensor1_img.txt
ls ../data/right_sub16.tif > run/sensor2_img.txt
ls ../data/left_sub16.json > run/sensor1_cam.txt
ls ../data/right_sub16.json > run/sensor2_cam.txt

bundle_adjust --solve-intrinsics --image-list run/sensor1_img.txt,run/sensor2_img.txt --camera-list run/sensor1_cam.txt,run/sensor2_cam.txt --intrinsics-to-float 1:focal_length,2:distortion --inline-adjustments --datum WGS84 -o run/run --num-iterations 10 --num-passes 1 --threads 1

