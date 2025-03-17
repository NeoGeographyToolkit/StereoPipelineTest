#!/bin/bash

set -x verbose
rm -rfv run

# Export RPC stored separately
cam_gen ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12_crop.tif --input-camera ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.xml --camera-type rpc -o run/run_rpc1.xml

# Export RPC embedded in the image
cam_gen --camera-type rpc ../data/2024-08-08-02-33-49_UMBRA-05_GEC.tif -o run/run_rpc2.xml

# Export RPC embedded in rpb
cam_gen ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif --input-camera ../data/camera.rpb --camera-type rpc -o run/run_rpc3.xml

