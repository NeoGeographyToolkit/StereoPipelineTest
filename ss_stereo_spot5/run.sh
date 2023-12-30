#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# This is very slow because loading XML cameras is so slow with libXML and this has large camera files
# Do cam_test only for now. Nothing much is happening for SPOT5 to be worth keeping track of.
#stereo --corr-timeout 300  ../data/spot5_front.bil ../data/spot5_back.bil ../data/spot5_front.dim ../data/spot5_back.dim run/run -t spot5 --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1 --left-image-crop-win 2771 57919 454 416 --right-image-crop-win 2855 57768 904 839
#point2dem -r Earth run/run-PC.tif --nodata-value -32767  --t_srs "+proj=stere +lat_0=-90 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"

cam_test --image ../data/spot5_front.bil --cam1 ../data/spot5_front.dim --cam2 ../data/spot5_front.dim --session1 spot5 --session2 spot5 --print-per-pixel-results --single-pixel 6000 6000 | grep -E "Min|Max|Median" > run/run.txt

