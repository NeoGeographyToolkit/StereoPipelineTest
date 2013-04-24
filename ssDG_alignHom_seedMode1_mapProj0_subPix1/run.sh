#!/bin/bash

d=../data
dir=run
rm -rfv $dir

stereo $d/WV01_11JAN131652275-P1BS-10200100104A0300.r12.tif $d/WV01_11JAN131653225-P1BS-1020010011862E00.r12.tif $d/WV01_11JAN131652275-P1BS-10200100104A0300.r12.xml $d/WV01_11JAN131653225-P1BS-1020010011862E00.r12.xml $dir/$dir --stereo-file stereo.default --left-image-crop-win 2048 0 1024 1024 -t dg --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1

point2dem -r Earth $dir/$dir-PC.tif --nodata-value -32767
