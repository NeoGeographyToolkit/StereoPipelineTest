#!/bin/bash

set -x verbose
rm -rfv run

camera_solve run/ ../data/AS15-M-0114_MED.png ../data/AS15-M-0115_MED.png --datum D_MOON --calib-file ../data/AS15_calib.tsai --gcp-file ../data/AS15_gcp.gcp --threads 1

parallel_stereo -t pinhole --stereo-algorithm libelas --alignment-method local_epipolar --left-image-crop-win 1793 1802 999 999 --right-image-crop-win 2220 1708 1258 1353 --corr-seed-mode 1 --sgm-collar-size 128 --threads 16 ../data/AS15-M-0114_MED.png ../data/AS15-M-0115_MED.png run/AS15-M-0114_MED.png.final.tsai run/AS15-M-0115_MED.png.final.tsai run/run

point2dem --stereographic --auto-proj-center run/run-PC.tif

