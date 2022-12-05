#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust --transform-cameras-with-shared-gcp --solve-intrinsics ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.brownconrady.tsai ../data/right_sub16.brownconrady.tsai ../data/gcp_sub16.gcp --inline-adjustments -t pinhole --datum WGS84 -o run/run  --intrinsics-to-float "other_intrinsics" --threads 1

