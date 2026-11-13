#!/bin/bash

set -x verbose
rm -rfv run

# Same as ss_cam_gen but adds --cam-ctr-weight, so during --refine-camera the
# camera center is constrained to stay near the initial value. Covers the
# cam_ctr_weight path in formCamera and fit_camera_to_xyz_ht.

cam_gen --datum WGS84 --height-above-datum 0 --lon-lat-values '-122.38 37.62 -122.35 37.62 -122.35 37.61 -122.39 37.61' --focal-length 28.968757624607505 --pixel-pitch 0.0063 --camera-center -2707432.6171838334 -4274312.8503553774 3872832.3088544519 --refine-camera --cam-ctr-weight 1000.0 ../data/DMS_20171029_183706_02501.tif -o run/run.tsai --gcp-file run/run.gcp
