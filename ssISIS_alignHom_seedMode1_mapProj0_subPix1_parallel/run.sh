#!/bin/bash

set -x verbose
rm -rfv run

mkdir -p run
uname -n >  run/machines.txt

# Test --nodata-value
parallel_stereo --enable-fill-holes --processes 2 --threads-multiprocess 8 --job-size-w 512 --job-size-h 512 --nodes-list run/machines.txt  ../data/M0100115_small.cub ../data/E0201461_small.cub run/run -s stereo.default  --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1 --corr-tile-size 512 --save-left-right-disparity-difference --nodata-value 0.12

# Test the situation when the proj4 string is specified as input with the datum name set separately
point2dem --t_srs '+proj=longlat +a=3396190 +b=3396190 +no_defs '   -r mars run/run-PC.tif --nodata-value -32767
