#!/bin/bash

set -x verbose
rm -rfv run

# Run cam_gen with a SkySat frame index and --parse-ecef, so the camera center
# comes from the ECEF satellite position in the frame index rather than being
# solved. This covers the ECEF parsing branch of parseFrameIndex, which the
# plain ss_cam_gen_frame_index test does not exercise.

cam_gen ../data/skysat/n1000.tiff --reference-dem ../data/skysat/uluru_copernicus.tif --focal-length 553846.153846 --optical-center 1280 540 --pixel-pitch 1 --height-above-datum 4000 --frame-index ../data/skysat/frame_index_skysat.csv --parse-ecef --gcp-std 1 -o run/n1000.tsai --gcp-file run/n1000.gcp
