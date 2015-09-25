#!/bin/bash

set -x verbose
rm -rfv run
#cam2map4stereo.py N1717567658_1.cal.cub N1717571087_1.cal.cub --lon -180:180     
stereo ../data/N1717567658_1.cal.map.cub ../data/N1717571087_1.cal.map.cub run/run --left-image-crop-win 1024 1024 2048 2048 --corr-timeout 15000  --ip-detect-method 1

gdal_translate -srcwin 0    0 2048 2942 run/run-PC.tif run/run-crop1-PC.tif
gdal_translate -srcwin 2048 0 2340 2942 run/run-PC.tif run/run-crop2-PC.tif

gdal_translate -srcwin 0    0 2048 2942 run/run-L.tif run/run-crop1-L.tif
gdal_translate -srcwin 2048 0 2340 2942 run/run-L.tif run/run-crop2-L.tif

point2dem --semi-major-axis 207400 --semi-minor-axis 190600 run/run-crop*-PC.tif run/run-crop*-L.tif  --remove-outliers --orthoimage -o run/run


