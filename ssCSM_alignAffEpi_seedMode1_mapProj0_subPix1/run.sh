#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/J03_045994_1986_XN_18N282W.cub ../data/J03_046060_1986_XN_18N282W.cub ../data/J03_045994_1986_XN_18N282W.json ../data/J03_046060_1986_XN_18N282W.json run/run --left-image-crop-win 2638 1970 932 883 --right-image-crop-win 2827 2606 779 883

point2dem -r mars run/run-PC.tif --nodata-value -32767

