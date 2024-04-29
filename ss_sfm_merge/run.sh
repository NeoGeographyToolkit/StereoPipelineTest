#!/bin/bash

set -x verbose
rm -rfv run

# Split
sfm_submap -input_map ../data/rig_calibrator_example_3_cameras/rig_input/cameras.nvm -image_list ../data/rig_calibrator_example_3_cameras/rig_input/camera_list1.txt -output_map run/submap1.nvm
sfm_submap -input_map ../data/rig_calibrator_example_3_cameras/rig_input/cameras.nvm -image_list ../data/rig_calibrator_example_3_cameras/rig_input/camera_list2.txt -output_map run/submap2.nvm

# Merge
sfm_merge --rig_config ../data/rig_calibrator_example_3_cameras/rig_input/rig_config.txt run/submap1.nvm run/submap2.nvm -num_image_overlaps_at_endpoints 4 -output_map run/merged.nvm -num_threads 1

