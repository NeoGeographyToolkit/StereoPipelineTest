#!/bin/bash

set -x verbose
rm -rfv run

mkdir run
bundle_adjust ../data/AS15-M-1134.lev1.cub ../data/AS15-M-1135.lev1.cub ../data/gcp1001.gcp --cost-function cauchy --robust-threshold 0.5 --max-iterations 100 -o run/ba/in --datum D_MOON

echo "1.005  0       0     200"  > transform.txt
echo "0      1.005   0     300" >> transform.txt
echo "0      0       1.005 400" >> transform.txt
echo "0      0       0       0" >> transform.txt

# Testing reading adjustments and applying a transform on top
bundle_adjust ../data/AS15-M-1134.lev1.cub ../data/AS15-M-1135.lev1.cub ../data/gcp1001.gcp --cost-function cauchy --robust-threshold 0.5 --max-iterations 100 -o run/ba/out --datum D_MOON --input-adjustments-prefix run/ba/in --initial-transform transform.txt

stereo --bundle-adjust-prefix run/ba/out ../data/AS15-M-1134.lev1.cub ../data/AS15-M-1135.lev1.cub run/run --left-image-crop-win 601 1348 441 407 --right-image-crop-win 1751 1393 516 441

point2dem run/run-PC.tif --errorimage
