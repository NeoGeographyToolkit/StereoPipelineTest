#!/bin/bash

set -x verbose
rm -rfv run

# Per-sensor mode with --intrinsics-to-share. Two sensors, two images each.
# The focal length and distortion are shared within each sensor, and the
# optical center is per camera. The second TC1 camera is given a different
# detector center, which must be kept, not copied from the first camera.

mkdir -p run

sed -e '/"detector_center"/,/}/ s/"line": 0.5/"line": 3.5/'           \
    -e '/"detector_center"/,/}/ s/"sample": 2048.0/"sample": 2073.0/' \
    ../data/kaguya/TC1W2B0_01_02935N034E0949.json                     \
    > run/TC1W2B0_01_02935N034E0949.json

ls ../data/kaguya/TC1W2B0_01_02934N034E0959.cub \
   ../data/kaguya/TC1W2B0_01_02935N034E0949.cub > run/tc1_images.txt
ls ../data/kaguya/TC2W2B0_01_02934N036E0959.cub \
   ../data/kaguya/TC2W2B0_01_02935N036E0949.cub > run/tc2_images.txt

ls ../data/kaguya/TC1W2B0_01_02934N034E0959.json \
   run/TC1W2B0_01_02935N034E0949.json > run/tc1_cameras.txt
ls ../data/kaguya/TC2W2B0_01_02934N036E0959.json \
   ../data/kaguya/TC2W2B0_01_02935N036E0949.json > run/tc2_cameras.txt

# The optical center is held fixed, so each camera must keep its own
bundle_adjust --solve-intrinsics                        \
  --inline-adjustments                                  \
  --intrinsics-to-float 'focal_length other_intrinsics' \
  --intrinsics-to-share 'focal_length other_intrinsics' \
  --image-list run/tc1_images.txt,run/tc2_images.txt    \
  --camera-list run/tc1_cameras.txt,run/tc2_cameras.txt \
  --match-files-prefix ../data/kaguya/ba/run            \
  --max-pairwise-matches 1000                           \
  --num-iterations 2                                    \
  --num-passes 1                                        \
  --threads 1                                           \
  -o run/fixed_center/run

# The optical center floats separately for each camera
bundle_adjust --solve-intrinsics                        \
  --inline-adjustments                                  \
  --intrinsics-to-float all                             \
  --intrinsics-to-share 'focal_length other_intrinsics' \
  --image-list run/tc1_images.txt,run/tc2_images.txt    \
  --camera-list run/tc1_cameras.txt,run/tc2_cameras.txt \
  --match-files-prefix ../data/kaguya/ba/run            \
  --max-pairwise-matches 1000                           \
  --num-iterations 2                                    \
  --num-passes 1                                        \
  --threads 1                                           \
  -o run/float_center/run
