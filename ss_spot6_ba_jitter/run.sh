#!/bin/bash

# Test bundle_adjust and jitter_solve with the SPOT 6/7 ("spot") session.
# Uses synthetic SPOT 6 cameras (NEO data in SPOT 6 XML skeleton).
# Images are 2000x2000 crops.

set -x verbose
rm -rfv run

left=../data/IMG_PNEO4_202304032140366_PAN_SEN_PWOI_000079416_1_2_F_1_P_R1C1_crop.tif
right=../data/IMG_PNEO4_202304032140266_PAN_SEN_PWOI_000079416_1_2_F_1_P_R1C1_crop.tif
left_cam=../data/DIM_SYNTH_SPOT6_LEFT.XML
right_cam=../data/DIM_SYNTH_SPOT6_RIGHT.XML

# Bundle adjust with 1 iteration. Produces .adjust and .adjusted_state.json.
bundle_adjust -t spot                \
  --num-iterations 1                 \
  --camera-weight 0                  \
  --tri-weight 0.1                   \
  --threads 1                        \
  $left $right $left_cam $right_cam  \
  -o run/ba/run

# Jitter solve with 1 iteration. Uses BA matches and adjusted cameras.
# With 2000-line images, 200 lines per knot gives ~10 knots.
jitter_solve                                 \
  --image-list run/ba/run-image_list.txt     \
  --camera-list run/ba/run-camera_list.txt   \
  --match-files-prefix run/ba/run            \
  --num-iterations 1                         \
  --num-lines-per-position 200               \
  --num-lines-per-orientation 200            \
  --threads 1                                \
  -o run/jitter/run

