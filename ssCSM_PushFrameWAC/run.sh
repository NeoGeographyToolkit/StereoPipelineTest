#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust ../data/M119923055ME.cub ../data/M119929852ME.cub ../data/M119923055ME.json ../data/M119929852ME.json -o run/ba/run

# A second bundle adjustment, to see if we can load the state
bundle_adjust ../data/M119923055ME.cub ../data/M119929852ME.cub ./run/ba/run-M119923055ME.adjusted_state.json ./run/ba/run-M119929852ME.adjusted_state.json -o run/ba_state/run

parallel_stereo --bundle-adjust-prefix run/ba/run --stereo-algorithm asp_mgm --left-image-crop-win 341 179 727 781 --right-image-crop-win 320 383 824 850 ../data/M119923055ME.cub ../data/M119929852ME.cub ../data/M119923055ME.json ../data/M119929852ME.json run/run

point2dem run/run-PC.tif

