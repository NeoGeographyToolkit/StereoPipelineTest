#!/bin/bash

set -x verbose
rm -rfv run

dataDir=../data/rig_calibrator_example_3_cameras

# Create the camera poses using Theia
theia_sfm --rig_config                            \
    ${dataDir}/rig_input/rig_config.txt           \
    --images "${dataDir}/rig_input/nav_cam/*tif
              ${dataDir}/rig_input/haz_cam/*tif 
               ${dataDir}/rig_input/sci_cam/*tif" \
    --out_dir run/rig_theia

# Run the rig calibrator. It will register the cameras,
# optimize the intrinsics, camera poses and rig transforms.
float="focal_length,optical_center,distortion"
float_all="nav_cam:${float} haz_cam:${float} sci_cam:${float}" 
rig_calibrator                                       \
    --rig_config ${dataDir}/rig_input/rig_config.txt \
    --nvm run/rig_theia/cameras.nvm                  \
    --camera_poses_to_float "nav_cam"                \
    --rig_transforms_to_float "sci_cam haz_cam"      \
    --intrinsics_to_float "$float_all"               \
    --depth_to_image_transforms_to_float "haz_cam"   \
    --affine_depth_to_image                          \
    --bracket_len 2.0                                \
    --depth_tri_weight 1000                          \
    --tri-weight 10                                  \
    --tri_robust_threshold 0.1                       \
    --num_iterations 20                              \
    --calibrator_num_passes 2                        \
    --num_overlaps 10                                \
    --registration                                   \
    --hugin_file ${dataDir}/control_points.pto       \
    --xyz_file ${dataDir}/xyz.txt                    \
    --export_to_voxblox                              \
    --save_transformed_depth_clouds                  \
    --out_dir run

rm -rfv run/rig_theia/matches # takes too much space

# Create a mesh using the images, depth clouds,
# and obtained optimized cameras
voxblox_mesh --index run/voxblox/haz_cam/index.txt \
    --output_mesh run/fused_mesh.ply               \
    --min_ray_length 0.1 --max_ray_length 4.0      \
    --voxel_size 0.01

# Create textured meshes for given sensors
for cam in nav_cam sci_cam; do 
  texrecon --rig_config run/rig_config.txt \
    --camera_poses run/cameras.txt         \
    --mesh run/fused_mesh.ply              \
    --rig_sensor ${cam}                    \
    --undistorted_crop_win '1000 800'      \
    --out_dir run/texrecon_out
done

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
multi_stereo --rig_config run/rig_config.txt \
    --camera_poses run/cameras.txt           \
    --undistorted_crop_win '1100 700'        \
    --rig_sensor nav_cam                     \
    --first_step stereo                      \
    --last_step  mesh_gen                    \
    --stereo_options "$stereo_opts"          \
    --pc_filter_options "$pc_filter_opts"    \
    --mesh_gen_options "$mesh_gen_opts"      \
    --first-image-index 2                    \
    --last-image-index 4                     \
  --out_dir run/stereo
