#!/bin/bash

set -x verbose
rm -rfv run
#cam2map4stereo.py N1717567658_1.cal.cub N1717571087_1.cal.cub --lon -180:180     
stereo ../data/N1717567658_1.cal.map.cub ../data/N1717571087_1.cal.map.cub run/run --left-image-crop-win 1024 1024 2048 2048
point2dem --semi-major-axis 207400 --semi-minor-axis 190600 run/run-PC.tif --remove-outliers



