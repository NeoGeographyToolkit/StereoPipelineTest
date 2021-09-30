#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --enable-fill-holes --left-image-crop-win 0 1024 672 4864 --alignment-method local_epipolar --subpixel-mode 1 --compute-error-vector --stereo-algorithm asp_mgm --corr-seed-mode 1 --stereo-file stereo.default --threads 16 ../data/M0100115_crop.cub ../data/E0201461.cub run/run 

point2dem -r mars run/run-PC.tif --nodata-value -32767 --errorimage --x-offset -161 --t_srs "+proj=eqc +lon_0=0 +x_0=0 +y_0=0 +a=3396190 +b=3396190 +units=m +no_defs" --tr 5

