#!/bin/bash

set -x verbose
rm -rfv run

# This tests rig_calibrator with the option --heights-from-dem.
# This test uses synthetic orbital rig data created from ASTER dataset 
# ../data/AST_L1A_00404012022185436_20250920182851.hdf
# The rig_calibrator constrains triangulated point heights to the ASTER DEM
# to demonstrate the new DEM height constraint functionality.

# Ensure that focal length is 1/20 of the altitude (700000 m). This should
# result in a pixel size of about 20 m which is somewhat more than nominal ASTER
# camera GSD.

# Rig config
# ref_sensor_name: left

# sensor_name: left
# focal_length: 35000
# optical_center: 500 500
# distortion_coeffs: 0
# distortion_type: no_distortion 
# image_size: 1000 1000
# distorted_crop_size: 1000 1000
# undistorted_image_size: 1000 1000
# ref_to_sensor_transform: 1 0 0 0 1 0 0 0 1 0 0 0
# depth_to_image_transform: 1 0 0 0 1 0 0 0 1 0 0 0
# ref_to_sensor_timestamp_offset: 0

# sensor_name: right
# focal_length: 35000
# optical_center: 500 500
# distortion_coeffs: 0
# distortion_type: no_distortion 
# image_size: 1000 1000
# distorted_crop_size: 1000 1000
# undistorted_image_size: 1000 1000
# ref_to_sensor_transform: 1 0 0 0 1 0 0 0 1 0 0 0
# depth_to_image_transform: 1 0 0 0 1 0 0 0 1 0 0 0
# ref_to_sensor_timestamp_offset: 0

# # sat_sim commands
# # Fwd
# sat_sim                              \
#   --dem ../data/aster-dem.tif        \
#   --ortho ../data/aster-ortho.tif    \
#   --rig-config ../data/aster_rig.txt \
#   --rig-sensor-ground-offsets        \
#     -0.01,0,-4000,0,0.01,0,4000,0    \
#   --first 1300 1200 700000           \
#   --last  1300 1500 700000           \
#   --first-ground-pos 1300 1200       \
#   --last-ground-pos  1300 1500       \
#   --roll 0 --pitch 30 --yaw 0        \
#   --num 3                            \
#   --velocity 7500                    \
#   -o sat_sim/run-fwd

# # Nadir
# sat_sim                              \
#   --dem ../data/aster-dem.tif        \
#   --ortho ../data/aster-ortho.tif    \
#   --rig-config ../data/aster_rig.txt \
#   --rig-sensor-ground-offsets        \
#     -0.01,0,-4000,0,0.01,0,4000,0    \
#   --first 1300 1200 700000           \
#   --last  1300 1500 700000           \
#   --first-ground-pos 1300 1200       \
#   --last-ground-pos  1300 1500       \
#   --roll 0 --pitch 0 --yaw 0         \
#   --num 3                            \
#   --velocity 7500                    \
#   -o sat_sim/run-nadir

# Move the data to ../data/orbital_rig to not recreate it every time. 

# Shorten the rig config name
# cp ../data/orbital_rig/sat_sim/run-nadir-rig_config.txt ../data/orbital_rig/rig_config.txt

# Bundle adjust, producing nvm
# parallel_bundle_adjust   \
#   --ip-per-image 10000   \
#   --output-cnet-type nvm \
#   ../data/orbital_rig/sat_sim/*{left,right}.tif  \
#   ../data/orbital_rig/sat_sim/*{left,right}.tsai \
#   -o ../data/orbital_rig/ba/run

# Run the rig calibrator with DEM height constraints
rig_calibrator                             \
  --rig-config                             \
  ../data/orbital_rig/rig_config.txt       \
  --nvm ../data/orbital_rig/ba/run.nvm     \
  --use-initial-rig-transforms             \
  --fix-rig-translations                   \
  --camera-poses-to-float "left right"     \
  --intrinsics-to-float                    \
  "left:focal_length right:focal_length"   \
  --camera-position-uncertainty 1.0        \
  --heights-from-dem ../data/aster-dem.tif \
  --heights-from-dem-uncertainty 2.0       \
  --heights-from-dem-robust-threshold 0.1  \
  --tri-weight 1.0                         \
  --save-pinhole-cameras                   \
  --num-iterations 10                      \
  --num-threads 1                          \
  --out-dir run
