#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Step 1. Refit the lens distortion of a CSM Frame camera (CaSSIS framelet, with
# the special CaSSIS vendor distortion) to the transverse model, keeping the pose
# and other intrinsics fixed. Run cam_test to validate the refit against the input
# camera.

cam_gen ../data/cassis_framelet.cub      \
  --input-camera ../data/cassis_framelet.json \
  --csm-refit-distortion                 \
  --distortion-type transverse           \
  --refine-intrinsics distortion         \
  --datum D_MARS                         \
  -o run/run.json

cam_test --image ../data/cassis_framelet.cub --cam1 ../data/cassis_framelet.json --cam2 run/run.json --datum D_MARS \
 | grep -v -i elapsed > run/run.txt

# Step 2. Transplant a different (solver-produced) transverse distortion into the
# refit camera from step 1 and re-solve only the pose, so the camera keeps imaging
# the same ground. The position is softly constrained with
# --camera-position-uncertainty, leaving the orientation free. Validate the result
# against the step-1 camera it conforms to.

LENS="-1.419214 0.979343 0.012797 0.000123 -0.000478 0.001206 -0.000021 0.000002 0.000004 0.00004 \
      -1.235949 0.000481 0.663847 -0.000168 0.000123 -0.037601 -0.000004 -0.000024 0.000004 -0.001436"

cam_gen ../data/cassis_framelet.cub      \
  --input-camera run/run.json            \
  --csm-refit-pose                       \
  --distortion-type transverse           \
  --distortion "$LENS"                   \
  --camera-position-uncertainty 100,100  \
  --reference-dem ../data/cassis_dem.tif \
  --datum D_MARS                         \
  --num-pixel-samples 4000               \
  -o run/pose.json

cam_test --image ../data/cassis_framelet.cub --cam1 run/run.json --cam2 run/pose.json --datum D_MARS \
 | grep -v -i elapsed > run/pose.txt
