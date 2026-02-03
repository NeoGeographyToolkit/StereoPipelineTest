#!/bin/bash
set -x verbose
rm -rfv run
# Run the rig calibrator. Test the ability to follow the convention for images from the doc. 
dataDir=../data/rig_calibrator_dir_conv
cams="nav_cam sci_cam haz_cam"
# Floating intrinsics
# intr="focal_length,optical_center,distortion"
# float_intr="nav_cam:${intr} haz_cam:${intr} sci_cam:${intr}"
# Not floating intrinsics
float_intr=""

rig_calibrator                                 \
  --rig-config ${dataDir}/rig_config.txt       \
  --nvm $dataDir/cameras.nvm                   \
  --camera-poses-to-float "$cams"              \
  --intrinsics-to-float "$float_intr"          \
  --depth-to-image-transforms-to-float "$cams" \
  --affine-depth-to-image                      \
  --bracket-len 2.0                            \
  --depth-tri-weight 1000                      \
  --tri-weight 10                              \
  --tri-robust-threshold 0.1                   \
  --num-iterations 5                           \
  --num-passes 2                               \
  --num-overlaps 0 --num-match-threads 8       \
  --num-threads 1                              \
  --out-dir run
 
