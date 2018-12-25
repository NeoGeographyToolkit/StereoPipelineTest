#!/bin/bash

set -x verbose
rm -rfv run

cam_gen --datum WGS84 --height-above-datum 0 --lon-lat-values '-122.38 37.62 -122.35 37.62 -122.35 37.61 -122.39 37.61' --focal-length 28.968757624607505 --optical-center 18.11581494334796 12.0750534040106 --pixel-pitch 0.0063 --refine-camera ../data/DMS_20171029_183706_02501.tif -o run/run.tsai --gcp-file run/run.gcp

