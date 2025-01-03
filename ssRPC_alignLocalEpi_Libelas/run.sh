#!/bin/bash

set -x verbose
rm -rfv run

# Test libelas with --nodata-value
parallel_stereo --stereo-algorithm libelas --corr-tile-size 650 --sgm-collar-size 200 --alignment-method local_epipolar ../data/img_01_crop.tif ../data/img_02.tif run/run --nodata-value 104

point2dem run/run-PC.tif

