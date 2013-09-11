#!/bin/bash

set -x verbose
rm -rfv run

echo localhost >  machines.txt

parallel_stereo --processes 2 --threads-multiprocess 8 --job-size-w 512 --job-size-h 512 --nodes-list machines.txt  ../data/M0100115_small.cub ../data/E0201461_small.cub run/run -s stereo.default  --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1
point2dem -r mars run/run-PC.tif --nodata-value -32767
