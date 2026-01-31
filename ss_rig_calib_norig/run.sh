#!/bin/bash

set -x verbose
rm -rfv run

# Test no rig and --image-sensor-list

mkdir -p run

# Given a file like: ../data/bay4/queen_nav/1654694783.7586150.jpg
# produce ../data/bay4/queen_nav/1654694783.7586150 queen_nav 1654694783.7586150
for f in $(grep  jpg ../data/norig.nvm | awk '{print $1}'); do
  g=$(basename $f)
  time=$(echo $g | perl -p -e "s#\.jpg##g")
  sensor=$(dirname $f | xargs basename)
  echo $f $sensor $time
done \
> run/image_sensor_list.txt

rig_calibrator                                     \
    --no-rig                                       \
    --read-nvm-no-shift                            \
    --rig-config                                   \
    ../data/norig_config.txt                       \
    --image-sensor-list run/image_sensor_list.txt  \
    --save-nvm-no-shift                            \
    --nvm ../data/norig.nvm                        \
    --out-dir run                                  \
    --camera-poses-to-float "bumble_nav queen_nav" \
    --depth-to-image-transforms-to-float ""        \
    --intrinsics-to-float ""                       \
    --bracket-len 1.0                              \
    --robust-threshold 0.5                         \
    --depth-tri-weight 1000                        \
    --tri-weight 0.1                               \
    --tri-robust-threshold 0.1                     \
    --num-iterations 5                             \
    --calibrator-num-passes 1                      \
    --export-to-voxblox                            \
    --num-overlaps 0                               \
    --max-reprojection-error 50                    \
    --min-triangulation-angle 0.001                \
    --initial-max-reprojection-error 5000          \
    --num-threads 1 # use 1 thread to get a unique result
