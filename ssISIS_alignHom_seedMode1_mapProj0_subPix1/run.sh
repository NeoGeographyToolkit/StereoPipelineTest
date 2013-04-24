#!/bin/bash

. ~oalexan1/bin/isis_setup.sh
d=../data
dir=run
rm -rfv $dir

stereo $d/M0100115.cub $d/E0201461.cub $dir/$dir -s stereo.default --left-image-crop-win 0 1024 672 4864 --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1
point2dem -r mars $dir/$dir-PC.tif --nodata-value -32767



