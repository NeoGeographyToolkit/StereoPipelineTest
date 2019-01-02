#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust --solve-intrinsics ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.photometrix.tsai ../data/right_sub16.photometrix.tsai ../data/gcp_sub16.gcp --inline-adjustments -t pinhole --datum WGS84 -o run/run --threads 1
