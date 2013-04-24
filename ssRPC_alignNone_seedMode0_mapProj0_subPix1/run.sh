#!/bin/bash

d=../data
dir=run
rm -rfv $dir

stereo $d/WV01_11JAN131652222-P1BS-10200100104A0300_sub8.tif $d/WV01_11JAN131653180-P1BS-1020010011862E00_sub8.tif $d/WV01_11JAN131652222-P1BS-10200100104A0300_sub8.xml $d/WV01_11JAN131653180-P1BS-1020010011862E00_sub8.xml $dir/$dir -s stereo.default --disable-fill-holes --corr-search -10 -10 10 10 --left-image-crop-win 4096 2048 1024 1024 -t rpc --alignment-method none --corr-seed-mode 0 --subpixel-mode 1
point2dem -r Earth $dir/$dir-PC.tif --nodata-value -32767
