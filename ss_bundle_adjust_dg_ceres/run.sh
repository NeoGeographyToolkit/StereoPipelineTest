#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

echo "1 0 0 2" > run/transform.txt
echo "0 1 0 0" >> run/transform.txt
echo "0 0 1 0" >> run/transform.txt
echo "0 0 0 0" >> run/transform.txt

bundle_adjust ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.tif ../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.tif ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.xml ../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.xml -o run/run --ip-detect-method 1 --initial-transform run/transform.txt --camera-weight 0.1 --rotation-weight 0.1 --translation-weight 0.1 --epipolar-threshold 150  --min-matches 15 --ip-per-tile 500 --threads 1

