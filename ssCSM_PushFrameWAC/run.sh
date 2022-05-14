#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust ../data/M119923055ME.cub ../data/M119929852ME.cub ../data/M119923055ME.json ../data/M119929852ME.json -o run/ba/run

parallel_stereo --bundle-adjust-prefix run/ba/run --stereo-algorithm asp_mgm --left-image-crop-win 341 179 727 781 --right-image-crop-win 320 383 824 850 ../data/M119923055ME.cub ../data/M119929852ME.cub ../data/M119923055ME.json ../data/M119929852ME.json run/run

point2dem run/run-PC.tif

