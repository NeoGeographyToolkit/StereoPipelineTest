#!/bin/bash

set -x verbose
rm -rfv run

# Run stereo with CSM cameras using images mapprojected with the RPC model

# First create matches
# This uses the DG session
bundle_adjust ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml -o run/ba/run --num-iterations 0

# Then create CSM cameras created from linescan DG cameras
jitter_solve ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml -o run/jitter/run --num-iterations 0 --match-files-prefix run/ba/run

# Create mapprojected images with RPC cameras
mapproject -t rpc ../data/stereo-DEM-09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml run/left_map.tif 

# Borrow the projection string and grid size from the previous image
mapproject -t rpc ../data/stereo-DEM-09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml run/right_map.tif --ref-map run/left_map.tif

# Run stereo with CSM and RPC-mapprojected images
stereo run/left_map.tif run/right_map.tif run/jitter/run-09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.adjusted_state.json run/jitter/run-09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.adjusted_state.json run/run ../data/stereo-DEM-09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif --left-image-crop-win 1458 224 748 762 --right-image-crop-win 1495 219 776 849

point2dem run/run-PC.tif
