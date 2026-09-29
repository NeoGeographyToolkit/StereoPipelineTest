#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

maxDistanceFromCamera=3.0

# Convergence angle report, as written by bundle_adjust: which image pairs to run
# stereo on, selected by median convergence angle (--conv-angle-range). Columns:
# left right 25% 50% 75% num_matches, with names as in the camera pose list. These
# are the second, third, and fourth nav_cam images, paired consecutively. Image one
# is skipped as too similar to image two, which fails stereo. This exercises the
# --conv-angle-list path (mode 'mesh'); --overlap-list is covered by the dem_mosaic
# tests.
img=../data/rig_calibrator_example_3_cameras/rig_input/nav_cam
conv=run/convergence_angles.txt
cat > $conv <<EOF
# left_image right_image 25% 50% 75% num_matches
$img/1637278317.5566902_nav_cam.tif $img/1637278322.5624499_nav_cam.tif 6 7 8 500
$img/1637278322.5624499_nav_cam.tif $img/1637278324.3117061_nav_cam.tif 6 7 8 500
EOF

stereo_opts="
  --stereo-algorithm asp_mgm
  --alignment-method affineepipolar
  --ip-per-image 3000
  --min-triangulation-angle 0.5
  --global-alignment-threshold 5
  --session nadirpinhole
  --no-datum
  --corr-seed-mode 1
  --corr-tile-size 5000
  --max-disp-spread 300
  --ip-inlier-factor 0.4
  --nodata-value 0"

pc_filter_opts="
  --max-camera-ray-to-surface-normal-angle 75
  --max-valid-triangulation-error 0.0025
  --max-distance-from-camera $maxDistanceFromCamera
  --blending-dist 50 --blending-power 1"

mesh_gen_opts="
  --min_ray_length 0.1
  --max_ray_length $maxDistanceFromCamera
  --voxel_size 0.01"

multi_stereo                                     \
    --mode mesh                                  \
    --processes 2                                \
    --threads 4                                  \
    --rig-config ../data/rig_test/rig_config.txt \
    --camera-poses ../data/rig_test/cameras.txt  \
    --conv-angle-list $conv                      \
    --conv-angle-range 3,15                      \
    --undistorted-crop-win '400 300'             \
    --rig-sensor nav_cam                         \
    --first-step stereo                          \
    --last-step  mesh_gen                        \
    --stereo-options "$stereo_opts"              \
    --pc-filter-options "$pc_filter_opts"        \
    --mesh-gen-options "$mesh_gen_opts"          \
  --output-prefix run/stereo/run
