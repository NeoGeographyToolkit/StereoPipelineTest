#!/bin/bash

set -x verbose
rm -rfv run

# Test --image-list
mkdir -p run
ls ../data/left_mars_rpc.tif ../data/right_mars_rpc.tif > run/image_list.txt
ls ../data/left_mars_rpc.xml ../data/right_mars_rpc.xml > run/camera_list.txt
bundle_adjust --image-list run/image_list.txt --camera-list run/camera_list.txt -o run/run -t rpc --datum mars --threads 1

