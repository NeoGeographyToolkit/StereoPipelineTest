#!/bin/bash

set -x verbose
rm -rfv run

stereo --corr-timeout 300  ../data/spot5_front.bil ../data/spot5_back.bil ../data/spot5_front.dim ../data/spot5_back.dim run/run -t spot5 --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1 --left-image-crop-win 2771 57919 454 416 --right-image-crop-win 2855 57768 904 839

point2dem -r Earth run/run-PC.tif --nodata-value -32767  --t_srs "+proj=stere +lat_0=-90 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
