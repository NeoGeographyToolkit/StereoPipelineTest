#!/bin/bash

set -x verbose
rm -rfv run

pc_align --max-displacement 100 ../data/ref-mars-DEM.tif ../data/ref-mars.csv  --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run  --semi-major-axis 3396190 --semi-minor-axis 3396190

