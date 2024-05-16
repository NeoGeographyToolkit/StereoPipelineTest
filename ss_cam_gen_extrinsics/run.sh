#!/bin/bash

set -x verbose
rm -rfv run

cam_gen --extrinsics ../data/cam_extrinsics.txt --sample-file ../data/cam_intrinsics.txt --datum WGS84

