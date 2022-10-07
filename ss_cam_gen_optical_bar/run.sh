#!/bin/bash

set -x verbose
rm -rfv run

cam_gen --camera-type opticalbar                                              \
    --lon-lat-values '99.55 31.266 101.866 31.55 101.916 31.416 99.55 31.133' \
    --sample-file ../data/DS1105-2248DA079_optical_bar.tsai                   \
    ../data/DS1105-2248DA079.tif                                              \
    --reference-dem ../data/optical_bar_dem.tif                               \
    -o run/run.tsai
    
