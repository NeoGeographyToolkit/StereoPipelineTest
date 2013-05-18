#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

parallel_stereo --processes 8 --threads-multiprocess 1 --job-size-w 1024 --job-size-h 1024 $d/M0100115.cub $d/E0201461.cub $dir/$dir -s stereo.default --left-image-crop-win 0 1024 672 4864 --alignment-method affineepipolar --corr-seed-mode 1 --subpixel-mode 1
point2dem -r mars $dir/$dir-PC.tif --nodata-value -32767



