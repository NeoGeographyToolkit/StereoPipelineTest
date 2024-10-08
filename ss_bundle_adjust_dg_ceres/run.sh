#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Test applying an initial transform and saving as nvm with non-pinhole cameras

echo "1 0 0 2" > run/transform.txt
echo "0 1 0 0" >> run/transform.txt
echo "0 0 1 0" >> run/transform.txt
echo "0 0 0 0" >> run/transform.txt

# Test applying a camera position constraint
rm -fv run/uncertainty.txt
for f in ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.tif ../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.tif; do 
	echo $f 10 10 >> run/uncertainty.txt
done

bundle_adjust ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.tif ../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.tif ../data/WV01_11JAN131652275-P1BS-10200100104A0300.r12.xml ../data/WV01_11JAN131653225-P1BS-1020010011862E00.r12.xml -o run/run --ip-detect-method 1 --initial-transform run/transform.txt --tri-weight 0.1 --epipolar-threshold 150  --min-matches 15 --ip-per-tile 500 --threads 1 --output-cnet-type nvm --camera-position-uncertainty run/uncertainty.txt

