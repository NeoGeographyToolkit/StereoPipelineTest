#!/bin/bash

set -x verbose
rm -rfv run

# Test adding additional images, using initial rig transforms,
# and --image_sensor_list

dataDir=../data/rig_calibrator_example_3_cameras
cams="nav_cam sci_cam haz_cam"
float_intr=""

rig_calibrator                                                     \
    --rig_config ${dataDir}/rig_input/rig_config.txt               \
    --nvm ${dataDir}/rig_input/submap.nvm                          \
    --image_sensor_list ${dataDir}/rig_input/image_sensor_list.txt \
    --extra-list ${dataDir}/rig_input/extra_list.txt               \
    --use-initial-rig-transforms                                   \
    --camera_poses_to_float "$cams"                                \
    --intrinsics_to_float "$float_intr"                            \
    --depth_to_image_transforms_to_float "$cams"                   \
    --affine_depth_to_image                                        \
    --bracket_len 2.0                                              \
    --depth_tri_weight 1000                                        \
    --tri-weight 10                                                \
    --tri_robust_threshold 0.1                                     \
    --num_iterations 5                                             \
    --calibrator_num_passes 1                                      \
    --num_overlaps 5                                               \
    --num_threads 1                                                \
    --out_dir run
