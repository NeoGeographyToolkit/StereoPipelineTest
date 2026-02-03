#!/bin/bash

set -x verbose
rm -rfv run

# Test adding additional images, using initial rig transforms,
# and --image-sensor-list

dataDir=../data/rig_calibrator_example_3_cameras
cams="nav_cam sci_cam haz_cam"
float_intr=""

rig_calibrator                                                     \
    --rig-config ${dataDir}/rig_input/rig_config.txt               \
    --nvm ${dataDir}/rig_input/submap.nvm                          \
    --image-sensor-list ${dataDir}/rig_input/image_sensor_list.txt \
    --extra-list ${dataDir}/rig_input/extra_list.txt               \
    --use-initial-rig-transforms                                   \
    --camera-poses-to-float "$cams"                                \
    --intrinsics-to-float "$float_intr"                            \
    --depth-to-image-transforms-to-float "$cams"                   \
    --affine-depth-to-image                                        \
    --bracket-len 2.0                                              \
    --depth-tri-weight 1000                                        \
    --tri-weight 10                                                \
    --tri-robust-threshold 0.1                                     \
    --num-iterations 5                                             \
    --num-passes 1                                                 \
    --num-overlaps 5                                               \
    --num-threads 1                                                \
    --out-dir run
