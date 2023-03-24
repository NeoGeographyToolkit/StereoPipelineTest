#!/bin/bash

set -x verbose
rm -rfv run

maxDistanceFromCamera=3.0

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

# Skip image 1 as being too similar to image 2.
# That will cause stereo to fail.
multi_stereo                                     \
    --rig_config ../data/rig_test/rig_config.txt \
    --camera_poses ../data/rig_test/cameras.txt  \
    --undistorted_crop_win '1100 700'            \
    --rig_sensor nav_cam                         \
    --first_step stereo                          \
    --last_step  mesh_gen                        \
    --stereo_options "$stereo_opts"              \
    --pc_filter_options "$pc_filter_opts"        \
    --mesh_gen_options "$mesh_gen_opts"          \
    --first-image-index 2                        \
    --last-image-index 4                         \
  --out_dir run/stereo
