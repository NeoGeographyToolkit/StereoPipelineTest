#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

# For sparse_disp
export PYTHONPATH=$PYTHONPATH:$HOME/packages/lib64/python2.6/site-packages/
export LD_LIBRARY_PATH=$HOME/projects/base_system/lib

stereo $d/M0100115.cub $d/E0201461.cub $dir/$dir -s stereo.default --left-image-crop-win 0 1024 672 4864 --alignment-method affineepipolar --corr-seed-mode 3 --subpixel-mode 1 --verbose
point2dem -r mars $dir/$dir-PC.tif --nodata-value -32767



