#!/bin/bash

set -x verbose
rm -rfv run

# Shared GCP
bundle_adjust --transform-cameras-with-shared-gcp --solve-intrinsics ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.brownconrady.tsai ../data/right_sub16.brownconrady.tsai ../data/gcp_sub16.gcp --inline-adjustments -t pinhole --datum WGS84 -o run/shared/run  --intrinsics-to-float "other_intrinsics" --num-iterations 10 --num-passes 1 --threads 1

# Indiv GCP. Reuse previous matches.
bundle_adjust --transform-cameras-using-gcp --solve-intrinsics ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.brownconrady.tsai ../data/right_sub16.brownconrady.tsai ../data/gcp_sub16.gcp --inline-adjustments -t pinhole --datum WGS84 -o run/indiv/run  --intrinsics-to-float "other_intrinsics" --num-iterations 10 --num-passes 1 --threads 1 --match-files-prefix run/shared/run
