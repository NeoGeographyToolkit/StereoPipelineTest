#!/bin/bash

set -x verbose
rm -rfv run

# Export RPC stored separately
cam_gen ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12_crop.tif --input-camera ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.xml --camera-type rpc -o run/run_rpc1.xml
# Export RPC embedded in the image
cam_gen --camera-type rpc ../data/2024-08-08-02-33-49_UMBRA-05_GEC.tif -o run/run_rpc2.xml

