#!/bin/bash

set -x verbose
rm -rfv run

# This tests camera_footprint in a borderline situation where there was a bug. Find footprint onto datum. 
camera_footprint --datum WGS_1984 ../data/camera_footprint.tif ../data/camera_footprint.tsai --output-kml run/run_datum.kml

# Find footprint onto DEM
camera_footprint --dem-file ../data/camera_footprint_dem.tif ../data/camera_footprint.tif ../data/camera_footprint.tsai --output-kml run/run_dem.kml

