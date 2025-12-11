#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Create lists of images and cameras
echo ../data/dem2gcp/13001_sub16.tif > run/image_list.txt
echo ../data/dem2gcp/14001_sub16.tif >> run/image_list.txt
echo ../data/dem2gcp/13001_rpc_deg3_sub16.tsai > run/camera_list.txt
echo ../data/dem2gcp/14001_rpc_deg3_sub16.tsai >> run/camera_list.txt  

# Copy the match file to the location expected by the prefix
cp ../data/dem2gcp/13001_sub16__14001_sub16.match run/run-13001_sub16__14001_sub16.match

dem2gcp                                             \
--warped-dem ../data/dem2gcp/run-DEM_crop_tr20.tif  \
--ref-dem ../data/dem2gcp/ref_tr20.tif              \
--warped-to-ref-disparity ../data/dem2gcp/run-F.tif \
--image-list run/image_list.txt                     \
--camera-list run/camera_list.txt                   \
--match-files-prefix run/run                        \
--search-len 5                                      \
--gcp-sigma 1                                       \
--max-num-gcp 1000                                  \
--output-gcp run/run.gcp

