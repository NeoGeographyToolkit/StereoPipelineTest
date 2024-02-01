#!/bin/bash

set -x verbose
rm -rfv run

# Run cam_gen with a Pinhole file in json format provided by Planet.

cam_gen ../data/1259344352.36984587_sc00104_c2_PAN_i0000000001.tif --input-camera ../data/1259344352.36984587_sc00104_c2_PAN_i0000000001_pinhole.json -o run/run.tsai
