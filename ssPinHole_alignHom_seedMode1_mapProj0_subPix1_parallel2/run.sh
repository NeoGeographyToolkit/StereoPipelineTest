#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

parallel_stereo --processes 2 --threads-multiprocess 8 --job-size-w 512 --job-size-h 1024 --correlation-timeout 600 $d/1n270487304eff90cip1952l0m1.tif $d/1n270487304eff90cip1952r0m1.tif $d/1n270487304eff90cip1952l0m1.cahvor $d/1n270487304eff90cip1952r0m1.cahvor $dir/$dir -s stereo.default  --left-image-crop-win 515 609 605 450 --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1
point2dem -r moon --nodata-value -32767 $dir/$dir-PC.tif
