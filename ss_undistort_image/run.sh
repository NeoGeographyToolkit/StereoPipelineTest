#!/bin/bash

set -x verbose
rm -rfv run

undistort_image ../data/image_float32.tif ../data/camera.tsai -o run/run.tif


