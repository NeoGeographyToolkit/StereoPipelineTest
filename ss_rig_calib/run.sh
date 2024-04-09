#!/bin/bash

set -x verbose
rm -rfv run

dataDir=../data/rig_calibrator_example_3_cameras

# Create the camera poses using Theia
theia_sfm --rig_config                           \
    ${dataDir}/rig_input/rig_config.txt          \
    --images "${dataDir}/rig_input/nav_cam/*tif
              ${dataDir}/rig_input/haz_cam/*tif 
              ${dataDir}/rig_input/sci_cam/*tif" \
    --theia_flags ../data/theia_flags.txt        \
    --out_dir run/rig_theia

# Run the rig calibrator. It will register the cameras,
# optimize the intrinsics, camera poses and rig transforms.
cams="nav_cam sci_cam haz_cam"

# Floating intrinsics
# intr="focal_length,optical_center,distortion"
# float_intr="nav_cam:${intr} haz_cam:${intr} sci_cam:${intr}"

# Not floating intrinsics
float_intr=""

rig_calibrator                                       \
    --rig_config ${dataDir}/rig_input/rig_config.txt \
    --nvm run/rig_theia/cameras.nvm                  \
    --camera_poses_to_float "$cams"                  \
    --intrinsics_to_float "$float_intr"              \
    --depth_to_image_transforms_to_float "$cams"     \
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
    --save-pinhole-cameras --save_matches            \
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
