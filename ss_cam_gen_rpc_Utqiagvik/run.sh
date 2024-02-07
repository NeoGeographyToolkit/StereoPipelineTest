#!/bin/bash

set -x verbose
rm -rfv run

# Find the best fit to a given RPC camera and save as CSM. Refine the distortion and focal length.

# Use the radtan model
cam_gen ../data/BSG-101-20220429-230006-23138454_georeferenced-pan.tif --reference-dem ../data/Utqiagvik_dem.tif --focal-length 463763.636364 --optical-center 3300 2200 --pixel-pitch 1 --input-camera ../data/BSG-101-20220429-230006-23138454_georeferenced-pan.tif --refine-camera -o run/run_radtan.json --refine-intrinsics focal_length,other_intrinsics --distortion-type radtan

# Use the transverse model
cam_gen ../data/BSG-101-20220429-230006-23138454_georeferenced-pan.tif --reference-dem ../data/Utqiagvik_dem.tif --focal-length 463763.636364 --optical-center 3300 2200 --pixel-pitch 1 --input-camera ../data/BSG-101-20220429-230006-23138454_georeferenced-pan.tif --refine-camera -o run/run_transverse.json --refine-intrinsics focal_length,other_intrinsics --distortion-type transverse

# Reuse the intrinsics in another model
cam_gen ../data/BSG-101-20220429-230006-23138454_georeferenced-pan.tif --reference-dem ../data/Utqiagvik_dem.tif --input-camera ../data/BSG-101-20220429-230006-23138454_georeferenced-pan.tif --refine-camera --refine-intrinsics none --sample-file run/run_transverse.json --pixel-pitch 1 -o run/run_transverse2.json

