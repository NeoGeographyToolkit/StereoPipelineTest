#!/bin/bash

set -x verbose
rm -rfv run

# Test for input DEMs that have NaN pixels
dem_mosaic --median ../data/dem1_nan.tif ../data/dem2_nan.tif -o run/run.tif

