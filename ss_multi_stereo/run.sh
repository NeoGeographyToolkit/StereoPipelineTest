#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

maxDistanceFromCamera=3.0

# Overlap list: which image pairs to run stereo on. Two columns, with names as in the
# camera pose list. These are the second, third, and fourth nav_cam images, paired
# consecutively. Image one is skipped as too similar to image two, which fails stereo.
img=../data/rig_calibrator_example_3_cameras/rig_input/nav_cam
ovl=run/overlap.txt
cat > $ovl <<EOF
$img/1637278317.5566902_nav_cam.tif $img/1637278322.5624499_nav_cam.tif
$img/1637278322.5624499_nav_cam.tif $img/1637278324.3117061_nav_cam.tif
EOF

stereo_opts="
  --stereo-algorithm asp_mgm
  --alignment-method affineepipolar
  --ip-per-image 10000
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
    --rig_config ../data/rig_test/rig_config.txt \
    --camera_poses ../data/rig_test/cameras.txt  \
    --overlap-list $ovl                          \
    --undistorted_crop_win '700 500'             \
    --rig_sensor nav_cam                         \
    --first_step stereo                          \
    --last_step  mesh_gen                        \
    --stereo_options "$stereo_opts"              \
    --pc_filter_options "$pc_filter_opts"        \
    --mesh_gen_options "$mesh_gen_opts"          \
  --out_dir run/stereo
