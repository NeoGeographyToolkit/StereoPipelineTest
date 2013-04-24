#!/bin/bash

. ~oalexan1/bin/isis_setup.sh
d=../data
dir=run
rm -rfv $dir

stereo $d/M0100115.map.cub $d/E0201461.map.cub $dir/$dir -s stereo.default --corr-search -300 -300 -200 -200 --left-image-crop-win 0 1024 672 4864 --alignment-method none --corr-seed-mode 0 --subpixel-mode 0
point2dem -r mars $dir/$dir-PC.tif --nodata-value -32767

