#!/bin/bash

set -x verbose
rm -rfv run

stereo -t ASTER ../data/aster-Band3N.tif ../data/aster-Band3B.tif ../data/aster-Band3N.xml ../data/aster-Band3B.xml run/run --left-image-crop-win 2523 3311 820 753 --right-image-crop-win 3186 4068 1082 1218

point2dem run/run-PC.tif
