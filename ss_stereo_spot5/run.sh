#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# This is very slow because loading XML cameras is so slow with libXML and this has large camera files
# Do cam_test only for now. Nothing much is happening for SPOT5 to be worth keeping track of.
# If stereo is ever re-enabled, select new crop windows in stereo_gui for the cropped images.
#stereo --corr-timeout 300  ../data/spot5_front_crop.bil ../data/spot5_back_crop.bil ../data/spot5_front_crop.dim ../data/spot5_back_crop.dim run/run -t spot5 --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1 --left-image-crop-win 0 0 454 416 --right-image-crop-win 0 0 904 839
#point2dem -r Earth run/run-PC.tif --nodata-value -32767  --t_srs "+proj=stere +lat_0=-90 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"

cam_test --image ../data/spot5_front_crop.bil --cam1 ../data/spot5_front_crop.dim --cam2 ../data/spot5_front_crop.dim --session1 spot5 --session2 spot5 --print-per-pixel-results --single-pixel 6000 6000 | grep -E "Min|Max|Median" > run/run.txt

