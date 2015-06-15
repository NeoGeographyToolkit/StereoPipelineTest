#!/bin/bash

set -x verbose
rm -rfv run

stereo -t nadirpinhole --alignment-method homography ../data/DZB1212-500082L002001_crop.tif ../data/DZB1212-500082L003001_crop.tif ../data/DZB1212-500082L002001_25pct.pinhole ../data/DZB1212-500082L003001_25pct.pinhole run/run --left-image-crop-win 6500 4000 1500 1100 --right-image-crop-win 1403 4002 1630 1104 

point2dem -r Earth run/run-PC.tif --nodata-value -32767

