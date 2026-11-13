#!/bin/bash

set -x verbose
rm -rfv run

# Same as ss_cam_gen but the camera center is given as lon-lat-height with
# --camera-center-llh instead of ECEF. Covers the --camera-center-llh code
# path in formCamera (geodetic_to_cartesian of the given center).

cam_gen --datum WGS84 --height-above-datum 0 --lon-lat-values '-122.38 37.62 -122.35 37.62 -122.35 37.61 -122.39 37.61' --focal-length 28.968757624607505 --pixel-pitch 0.0063 --camera-center-llh -122.3509622842 37.6176308144 1505.026456 --refine-camera ../data/DMS_20171029_183706_02501.tif -o run/run.tsai --gcp-file run/run.gcp
