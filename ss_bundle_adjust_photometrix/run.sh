#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust --solve-intrinsics ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.tsai ../data/right_sub16.tsai ../data/gcp_sub16.gcp --local-pinhole -t pinhole --datum WGS84 -o run/run
