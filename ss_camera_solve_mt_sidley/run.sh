#!/bin/bash

set -x verbose
rm -rfv run

camera_solve run/ ../data/mt_sidley_47.tif ../data/mt_sidley_48.tif --calib-file camera_info.txt  --gcp-file ground_control_points.gcp

stereo ../data/mt_sidley_47.tif ../data/mt_sidley_48.tif run/mt_sidley_47.tif.pinhole run/mt_sidley_48.tif.pinhole run/out --left-image-crop-win 1891 6034 690 345  --right-image-crop-win 4750 5889 708 369

point2dem run/out-PC.tif
