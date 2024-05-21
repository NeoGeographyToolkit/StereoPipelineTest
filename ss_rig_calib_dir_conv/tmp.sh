#!/bin/bash
set -x verbose
rm -rfv run
# Run the rig calibrator. The convention for images is 
# assumed to be path/sensor/timestamp.tif
dataDir=../data/rig_calibrator_dir_conv
cams="nav_cam sci_cam haz_cam"
# Floating intrinsics
# intr="focal_length,optical_center,distortion"
# float_intr="nav_cam:${intr} haz_cam:${intr} sci_cam:${intr}"
# Not floating intrinsics
float_intr=""

rig_calibrator  
  --rig_config ${dataDir}/rig_config.txt \ 
  --nvm $dataDir/cameras.nvm \ 
  --camera_poses_to_float "$cams" \ 
  --intrinsics_to_float "$float_intr"   
  --depth_to_image_transforms_to_float "$cams"   
  --affine_depth_to_image   
  --bracket_len 2.0   
  --depth_tri_weight 1000   
  --tri-weight 10   
  --tri_robust_threshold 0.1   
  --num_iterations 5   
  --calibrator_num_passes 2   
  --num_overlaps 0 -num_match_threads 8   
  --num_threads 1   
  --out_dir run  
