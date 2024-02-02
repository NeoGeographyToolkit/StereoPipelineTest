#!/bin/bash

set -x verbose
rm -rfv run

# Find the best fit to a given RPC camera and save as CSM. Refine the distortion and focal length. 
cam_gen ../data/BSG-101-20220429-230006-23138454_georeferenced-pan.tif --reference-dem ../data/Utqiagvik_dem.tif --focal-length 463763.636364 --optical-center 3300 2200 --pixel-pitch 1 --input-camera ../data/BSG-101-20220429-230006-23138454_georeferenced-pan.tif --refine-camera -o run/run.json --refine-intrinsics focal_length,other_intrinsics --datum WGS84
