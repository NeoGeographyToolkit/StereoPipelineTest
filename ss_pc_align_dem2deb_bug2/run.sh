#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/basalt-DEM2.tif ../data/basalt-DEM3.tif -o run/run --max-displacement 100  --save-transformed-source-points --save-inv-transformed-reference-points 


