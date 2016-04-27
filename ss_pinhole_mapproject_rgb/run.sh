#!/bin/bash

set -x verbose
rm -rfv run

mapproject --mpp 5 WGS84 --datum-offset 30 ../data/icebridge_rgb.jpg ../data/icebridge_rgb.tsai run/run-ortho.tif --t_srs "+proj=stere +lat_0=-90 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
