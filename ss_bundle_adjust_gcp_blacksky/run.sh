#!/bin/bash

set -x verbose
rm -rfv run

# Bundle adjustment to purely initialize a camera with GCP
# This is a testcase for which a bug was fixed
bundle_adjust --inline-adjustments ../data/BSG-118-20220730-123737-33360052_georeferenced-pan.tif ../data/BSG-118-20220730-123737-33360052_georeferenced-pan.tsai ../data/BSG-118-20220730-123737-33360052_georeferenced-pan.gcp -o run/run --datum WGS84

