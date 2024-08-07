#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --alignment-method epipolar \
    --xcorr-threshold -1 --corr-kernel 5 5  \
    --corr-tile-size 2048 --corr-memory-limit-mb 6096  \
    --cost-mode 4 --stereo-algorithm asp_mgm --threads-single 8 \
    --corr-seed-mode 1 --session-type pinhole \
	--horizontal-stddev 1 1 \
	--propagate-errors \
	--left-image-crop-win 0 0 2000 2000 \
	--right-image-crop-win 0 0 2000 2000 \
    ../data/img_icebridge2.tif ../data/img_icebridge3.tif \
    ../data/img_icebridge2.tsai ../data/img_icebridge3.tsai \
    run/run

point2dem  --t_srs '+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs' --tr 0.4 run/run-PC.tif --errorimage --propagate-errors

