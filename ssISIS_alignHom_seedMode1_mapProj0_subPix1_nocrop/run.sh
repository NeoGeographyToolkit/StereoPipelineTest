#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

stereo $d/M0100115_small.cub $d/E0201461_small.cub $dir/$dir -s stereo.default  --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1
point2dem -r mars $dir/$dir-PC.tif --nodata-value -32767



