#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust ../data/DMS_20171029_183704_02500.tif ../data/DMS_20171029_183706_02501.tif ../data/DMS_20171029_183707_02502.tif ../data/DMS_20171029_183704_02500.tsai ../data/DMS_20171029_183706_02501.tsai ../data/DMS_20171029_183707_02502.tsai -o run/run --ip-per-tile 2000 --num-passes 2 --remove-outliers-params "75 3 1 2" --threads 1

