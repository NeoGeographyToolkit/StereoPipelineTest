#!/bin/bash

set -x verbose

rm -rfv run

echo localhost > machines.txt
par_opts="--processes 4 --threads-multi 2 --job-size-w 1024 --job-size-h 1024 --corr-timeout 600 --entry-point 0 --stop-point 6 --nodes-list machines.txt"

parallel_stereo $par_opts ../data/M0100115.map.cub ../data/E0201461.map.cub run/run -s stereo.default --corr-search -300 -300 -200 -200 --left-image-crop-win 0 1024 672 4864 --alignment-method none --corr-seed-mode 0 --subpixel-mode 0 --verbose --compute-error-vector
point2dem -r mars run/run-PC.tif --nodata-value -32767 --errorimage


