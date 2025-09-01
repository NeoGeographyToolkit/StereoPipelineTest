#!/bin/bash

set -x verbose
rm -rfv run

# This tests camera_footprint in a borderline situation where there was a bug 
camera_footprint --datum WGS_1984 ../data/camera_footprint.tif ../data/camera_footprint.tsai --output-kml run/run.kml

