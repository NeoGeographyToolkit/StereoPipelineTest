#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

echo localhost >  machines.txt

parallel_stereo --processes 2 --threads-multiprocess 8 --job-size-w 512 --job-size-h 512 --nodes-list machines.txt  $d/M0100115_small.cub $d/E0201461_small.cub $dir/$dir -s stereo.default  --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1
point2dem -r mars $dir/$dir-PC.tif --nodata-value -32767
