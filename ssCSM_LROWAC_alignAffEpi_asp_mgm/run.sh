#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --stereo-algorithm asp_mgm --left-image-crop-win 406 1971 522 556 --right-image-crop-win 235 2177 734 821 ../data/M119923055ME.cub ../data/M119929852ME.cub ../data/M119923055ME.json ../data/M119929852ME.json run/run

point2dem run/run-PC.tif

