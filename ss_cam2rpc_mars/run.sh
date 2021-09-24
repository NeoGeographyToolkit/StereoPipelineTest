#!/bin/bash

# Run stereo with cam2rpc-ed cameras. Those set the datum which stereo later uses.

set -x verbose
rm -rfv run

cam2rpc ../data/M0100115.cub run/M0100115.xml --session-type isis --datum D_MARS --save-tif-image --height-range -10020.707 -9925.348 --lon-lat-range 141.5447632 34.3363034 141.5701589 34.3063306 --num-samples 10 --penalty-weight 0.03 --gsd 1
cam2rpc ../data/E0201461.cub run/E0201461.xml --session-type isis --datum D_MARS --save-tif-image --height-range -10020.707 -9925.348 --lon-lat-range 141.5447632 34.3363034 141.5701589 34.3063306 --num-samples 10 --penalty-weight 0.03 --gsd 1

stereo --ip-per-tile 10000 --corr-seed-mode 1 --threads 16 run/M0100115.tif run/E0201461.tif run/M0100115.xml run/E0201461.xml run/run
point2dem run/run-PC.tif

