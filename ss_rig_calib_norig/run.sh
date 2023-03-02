#!/bin/bash

set -x verbose
rm -rfv run

rig_calibrator                                     \
    --no_rig                                       \
    --read_nvm_no_shift                            \
    --rig_config                                   \
    ../data/norig_config.txt                       \
    --save_nvm_no_shift                            \
    --nvm ../data/norig.nvm                        \
    --out_dir run                                  \
    --camera_poses_to_float "bumble_nav queen_nav" \
    --depth_to_image_transforms_to_float ""        \
    --intrinsics_to_float ""                       \
    --bracket_len 1.0                              \
    --robust-threshold 0.5                         \
    --depth_tri_weight 1000                        \
    --tri_weight 0.1                               \
    --tri_robust_threshold 0.1                     \
    --num_iterations 5                             \
    --calibrator_num_passes 1                      \
    --export_to_voxblox                            \
    --num_overlaps 0                               \
    --max_reprojection_error 50                    \
    --min_triangulation_angle 0.001                \
    --initial_max_reprojection_error 5000          \
    --num_threads 1 # use 1 thread to get a unique result
