#!/bin/bash

set -x verbose
rm -rfv run

# Use a DEM to create an RPC camera
cam2rpc --dem-file ../data/sat_sim_DEM.tif  ../data/cam2rpc.tif ../data/cam2rpc.tsai run/dem_cam.xml

# Use a lon-lat-height range to create an RPC camera
cam2rpc --datum D_MARS ../data/cam2rpc.tif ../data/cam2rpc.tsai run/llh_cam.xml --lon-lat-range 141.54898000443791 34.22559122255916 141.56529037850123 34.211986717004038 --height-range -10488.166 -9814.194 --num-samples 20

echo Validating the DEM-based RPC camera
cam_test --image ../data/cam2rpc.tif --cam1 ../data/cam2rpc.tsai --cam2 run/dem_cam.xml --height-above-datum -11488.1

echo Validating the lon-lat-height-based camera
cam_test --image ../data/cam2rpc.tif --cam1 ../data/cam2rpc.tsai --cam2 run/llh_cam.xml --height-above-datum -11488.1

