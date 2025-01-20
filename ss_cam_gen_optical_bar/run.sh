#!/bin/bash

set -x verbose
rm -rfv run
    
ll_vals='99.55 31.266 101.866 31.55 101.916 31.416 99.55 31.133' 
sampFile=../data/DS1105-2248DA079_optical_bar.tsai
cam_gen                                       \
  --camera-type opticalbar                    \
  --lon-lat-values "$ll_vals"                 \
  --sample-file $sampFile                     \
  ../data/DS1105-2248DA079.tif                \
  --reference-dem ../data/optical_bar_dem.tif \
  --refine-camera                             \
  -o run/run.tsai
