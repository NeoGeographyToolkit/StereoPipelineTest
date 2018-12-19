#!/bin/bash

set -x verbose
rm -rfv run

# Bundle adjustment to purely initialize a camera with GCP
bundle_adjust ../data/DMS_20171029_183706_02501.tif ../data/DMS_20171029_183706_02501.tsai ../data/DMS_20171029_183706_02501.gcp -o run/run --datum WGS84 --create-pinhole-cameras --camera-weight 0 --max-iterations 10 --threads 1
