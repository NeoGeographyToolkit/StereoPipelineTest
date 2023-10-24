#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust -t aster ../data/aster-Band3N.tif ../data/aster-Band3B.tif ../data/aster-Band3N.xml ../data/aster-Band3B.xml -o run/ba/run --threads 1 --num-iterations 10

stereo -t aster ../data/aster-Band3N.tif ../data/aster-Band3B.tif ../data/aster-Band3N.xml ../data/aster-Band3B.xml run/run --left-image-crop-win 2523 3311 820 753 --right-image-crop-win 3186 4068 1082 1218 --bundle-adjust-prefix run/ba/run

point2dem run/run-PC.tif

