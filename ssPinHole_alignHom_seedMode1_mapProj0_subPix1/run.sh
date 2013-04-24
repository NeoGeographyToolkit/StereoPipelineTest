#!/bin/bash

d=../data
dir=run
rm -rfv $dir

stereo $d/1n270487304eff90cip1952l0m1.tif $d/1n270487304eff90cip1952r0m1.tif $d/1n270487304eff90cip1952l0m1.cahvor $d/1n270487304eff90cip1952r0m1.cahvor $dir/$dir -s stereo.default --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1
point2dem -r moon --nodata-value -32767 $dir/$dir-PC.tif




