#!/bin/bash

set -x verbose
rm -rfv run

# Stereo with mapprojected images

stereo ../data/wv_ms_left.tif ../data/wv_ms_right.tif ../data/wv_ms_left.xml ../data/wv_ms_right.xml run/run --left-image-crop-win 127 3789 344 319 --right-image-crop-win 67 4446 517 528 --band 2

point2dem run/run-PC.tif

