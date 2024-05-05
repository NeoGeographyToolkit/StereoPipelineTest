#!/bin/bash

set -x verbose
rm -rfv run

# Run the rig calibrator. It will register the cameras,
# optimize the intrinsics, camera poses and rig transforms.
# Start with an existing Theia run.
# Use one thread for uniqueness.

dataDir=../data/rig_calibrator_example_3_cameras
cams="nav_cam sci_cam haz_cam"

# Floating intrinsics
# intr="focal_length,optical_center,distortion"
# float_intr="nav_cam:${intr} haz_cam:${intr} sci_cam:${intr}"
# Not floating intrinsics
float_intr=""

rig_calibrator                                       \
    --rig_config ${dataDir}/rig_input/rig_config.txt \
    --nvm ${dataDir}/rig_theia/cameras.nvm           \
    --camera_poses_to_float "$cams"                  \
    --intrinsics_to_float "$float_intr"              \
    --depth_to_image_transforms_to_float "$cams"     \
    --affine_depth_to_image                          \
    --bracket_len 2.0                                \
    --depth_tri_weight 1000                          \
    --tri-weight 10                                  \
    --tri_robust_threshold 0.1                       \
    --num_iterations 5                               \
    --calibrator_num_passes 2                        \
    --num_overlaps 3                                 \
    --registration                                   \
    --hugin_file ${dataDir}/control_points.pto       \
    --xyz_file ${dataDir}/xyz.txt                    \
    --export_to_voxblox                              \
    --save_transformed_depth_clouds                  \
    --save-pinhole-cameras --save_matches            \
    -num_match_threads 8                             \
    --num_threads 1                                  \
    --out_dir run

rm -rfv run/rig_theia/matches # takes too much space

# Run bundle adjustment with match files
bundle_adjust                         \
  --image-list run/image_list.txt     \
  --camera-list run/camera_list.txt   \
  --match-files-prefix run/matches/run\
  --num-iterations 5                  \
  --threads 1                         \
  -o run/ba_matches/run

# Run bundle adjustment with nvm
bundle_adjust                         \
  --image-list run/image_list.txt     \
  --camera-list run/camera_list.txt   \
  --nvm run/cameras.nvm               \
  --num-iterations 5                  \
  --threads 1                         \
  -o run/ba_nvm/run

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

