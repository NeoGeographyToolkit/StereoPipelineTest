#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust -t aster --aster-use-csm ../data/aster-Band3N.tif ../data/aster-Band3B.tif ../data/aster-Band3N.xml ../data/aster-Band3B.xml -o run/ba/run --threads 1 --num-iterations 3

stereo -t aster --aster-use-csm ../data/aster-Band3N.tif ../data/aster-Band3B.tif ../data/aster-Band3N.xml ../data/aster-Band3B.xml run/run --left-image-crop-win 2846 3290 491 509 --right-image-crop-win 3507 4000 751 729 --bundle-adjust-prefix run/ba/run

point2dem run/run-PC.tif

