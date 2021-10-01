#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --left-image-crop-win 0 1024 672 4864 --alignment-method local_epipolar  --compute-error-vector --stereo-algorithm asp_mgm --corr-seed-mode 1 --threads 16 ../data/M0100115_crop.cub ../data/E0201461.cub run/run 

point2dem -r mars run/run-PC.tif --nodata-value -32767

