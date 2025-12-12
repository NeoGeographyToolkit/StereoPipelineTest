#!/bin/bash

set -x verbose
rm -rfv run

# Logic to test stereo_gui with GCP creation. This cannot be run automatically as it needs the gui. Run manually if something changes.
#stereo_gui ../data/M181058717LE.ce.cub ../data/M181073012LE.ce.cub run/run-DEM.tif --dem-file run/run-DEM.tif --gcp-file run/gcp3.gcp --gcp-sigma 1 run/run

parallel_stereo --left-image-crop-win 3583 3922 1767 1691 --right-image-crop-win 4095 4348 1498 1668 --threads 16 --corr-seed-mode 1 ../data/M181058717LE.ce.cub ../data/M181073012LE.ce.cub ../data/M181058717LE.ce.json ../data/M181073012LE.ce.json run/run --corr-tile-size 3072 --sgm-collar-size 256 --alignment-method affineepipolar --stereo-algorithm asp_bm --save-left-right-disparity-difference

point2dem run/run-PC.tif

corr_eval --metric ncc    run/run-L.tif run/run-R.tif run/run-F.tif run/run
corr_eval --metric stddev run/run-L.tif run/run-R.tif run/run-F.tif run/run

