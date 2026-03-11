#!/bin/bash

set -x verbose
rm -rfv run

stereo -t RPC ../data/aster-Band3N.tif ../data/aster-Band3B.tif ../data/aster-Band3N.xml ../data/aster-Band3B.xml run/run --left-image-crop-win 2523 3411 500 500 --right-image-crop-win 3186 4268 700 700

point2dem run/run-PC.tif
