#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Refit the lens distortion of a CSM Frame camera (CaSSIS framelet, with the
# special CaSSIS distortion) to the transverse model, keeping the pose and other
# intrinsics fixed. Run cam_test to validate the refit against the input camera.

cam_gen ../data/cassis_framelet.cub      \
  --input-camera ../data/cassis_framelet.json \
  --csm-refit-distortion                 \
  --distortion-type transverse           \
  --refine-intrinsics distortion         \
  --datum D_MARS                         \
  -o run/run.json

cam_test --image ../data/cassis_framelet.cub --cam1 ../data/cassis_framelet.json --cam2 run/run.json --datum D_MARS \
 | grep -v -i elapsed > run/run.txt
