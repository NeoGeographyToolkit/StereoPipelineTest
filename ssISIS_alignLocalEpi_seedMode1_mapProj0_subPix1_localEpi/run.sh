#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --enable-fill-holes ../data/M0100115_crop.cub ../data/E0201461.cub run/run -s stereo.default --left-image-crop-win 0 1024 672 4864 --alignment-method local_epipolar --corr-seed-mode 1 --subpixel-mode 1  --compute-error-vector

point2dem -r mars run/run-PC.tif --nodata-value -32767 --errorimage --x-offset -161 --t_srs "+proj=eqc +lon_0=0 +x_0=0 +y_0=0 +a=3396190 +b=3396190 +units=m +no_defs" --tr 5


