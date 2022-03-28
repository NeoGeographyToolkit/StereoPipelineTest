#!/bin/bash

set -x verbose
rm -rfv run

stereo --corr-timeout 6000 ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.tif ../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.tif ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.xml ../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.xml run/run --disable-fill-holes --stereo-file stereo.default --left-image-crop-win 1232 227 2271 1235 --right-image-crop-win 1324 298 2041 1174  -t dg --alignment-method affineepipolar --corr-seed-mode 1 --subpixel-mode 1  --ip-per-tile 10000

point2dem -r Earth run/run-PC.tif --orthoimage run/run-L.tif --nodata-value -32767 --orthoimage-hole-fill-len 100 --max-valid-triangulation-error 1000 --orthoimage-hole-fill-extra-len 20 --stereographic --proj-lon 0 --proj-lat -90

