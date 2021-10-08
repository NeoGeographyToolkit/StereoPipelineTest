#!/bin/bash

set -x verbose
rm -rfv run

# Run cam_gen with a given frame index file.
# TODO(oalexan1): Allow fixing the camera center and floating the pose.
# See why results differ so much from what Shashank obtains in 
# ../data/skysat/n1000.tsai.
# Note that that directory also has his cameras and images for 
# not just nadir (n) but also for forward (f) and aft (a). This
# should help figure things out as some of those make stereo pairs.

cam_gen ../data/skysat/n1000.tiff --reference-dem ../data/skysat/uluru_copernicus.tif --focal-length 553846.153846 --optical-center 1280 540 --pixel-pitch 1 --height-above-datum 4000 --frame-index ../data/skysat/frame_index_skysat.csv --gcp-std 1 -o run/n1000.tsai --gcp-file run/n1000.gcp

