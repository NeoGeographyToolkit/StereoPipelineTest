#!/bin/bash

set -x verbose
rm -rfv run

# Convert an optical bar camera model to CSM linescan

# Left cam
cam_gen --camera-type linescan                   \
  ../data/D3C1214-100097A013.jpg                 \
  --input-camera ../data/D3C1214-100097A013.tsai \
  -o run/left_cam.json
# Right cam
cam_gen --camera-type linescan                   \
  ../data/D3C1214-100097F012.jpg                 \
  --input-camera ../data/D3C1214-100097F012.tsai \
  -o run/right_cam.json

