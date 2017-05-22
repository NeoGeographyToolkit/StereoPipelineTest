#!/bin/bash

set -x verbose
rm -rfv run

cam2rpc ../data/M0100115.cub run/run.xml --session-type isis --datum D_MARS --save-tif-image --height-range -10020.707 -9925.348 --lon-lat-range 141.5447632 34.3363034 141.5701589 34.3063306 --num-samples 10 --penalty-weight 0.03 --gsd 1
