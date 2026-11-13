#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Refit the lens distortion of an ISIS frame cube (Apollo 15 Metric) to the
# transverse model with --csm-refit-distortion, reading the focal length,
# optical center, and pose from the cube directly. Covers both the ISIS-frame
# intrinsic-reading path and isisCubMetadata (ephemeris time, sun position,
# serial number, target name), which no other cam_gen test exercises.

cam_gen ../data/AS15-M-0760.lev1_crop.cub --input-camera ../data/AS15-M-0760.lev1_crop.cub --csm-refit-distortion --distortion-type transverse --refine-intrinsics distortion --datum D_MOON -o run/run.json
