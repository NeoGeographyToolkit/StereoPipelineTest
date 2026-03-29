#!/bin/bash

# Test bundle_adjust and jitter_solve with the SPOT5 CSM session.
# Uses cropped SPOT5 stereo pair (front/back, Antarctica).
# bundle_adjust and jitter_solve auto-enable CSM for SPOT5 internally.

set -x verbose
rm -rfv run

left=../data/spot5_front_crop.bil
right=../data/spot5_back_crop.bil
left_cam=../data/spot5_front_crop.dim
right_cam=../data/spot5_back_crop.dim

# Bundle adjust with 1 iteration. Produces .adjust and .adjusted_state.json.
bundle_adjust -t spot5                 \
  --num-iterations 1                   \
  --camera-weight 0                    \
  --tri-weight 0.1                     \
  --threads 1                          \
  $left $right $left_cam $right_cam    \
  -o run/ba/run

# Jitter solve with 1 iteration. Uses BA matches and adjusted cameras.
# With 24042-line images, 2000 lines per pose sample gives ~12 samples.
jitter_solve                                 \
  --image-list run/ba/run-image_list.txt     \
  --camera-list run/ba/run-camera_list.txt   \
  --match-files-prefix run/ba/run            \
  --num-iterations 1                         \
  --num-lines-per-position 2000              \
  --num-lines-per-orientation 2000           \
  --threads 1                                \
  -o run/jitter/run
