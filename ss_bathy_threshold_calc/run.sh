#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Estimate the water-land threshold from the NIR (band 7) image with the KDE
# histogram tool. This needs the 'bathy' conda env (extra Python modules), so
# it is kept as its own test, separate from the bathy stereo test
# (ssDG_alignAffEpp_seedMode1_mapProj0_bathy).
~oalexan1/miniconda3/envs/bathy/bin/python $(which bathy_threshold_calc.py) \
    --image ../data/left_bathy_b7.tif --num-samples 100000                  \
    --no-plot | grep -v -i elapsed > run/run-threshold.txt
