#!/bin/bash

set -x verbose
rm -rfv run
#cam2map4stereo.py N1717567658_1.cal.cub N1717571087_1.cal.cub --lon -180:180
stereo ../data/N1717567658_1.cal.map.cub ../data/N1717571087_1.cal.map.cub run/run --left-image-crop-win 1955 216 300 300 --corr-timeout 15000  --ip-detect-method 0 --ip-per-image 10000

# Test point2dem with two clouds

# Also test point2dem when borrowing the datum from the input map-projected images

gdal_translate -srcwin 0    0 200 386 run/run-PC.tif run/run-crop1-PC.tif
gdal_translate -srcwin 200 0 186 386 run/run-PC.tif run/run-crop2-PC.tif

gdal_translate -srcwin 0    0 200 386 run/run-L.tif run/run-crop1-L.tif
gdal_translate -srcwin 200 0 186 386 run/run-L.tif run/run-crop2-L.tif

point2dem run/run-crop*-PC.tif run/run-crop*-L.tif  --remove-outliers --orthoimage -o run/run


