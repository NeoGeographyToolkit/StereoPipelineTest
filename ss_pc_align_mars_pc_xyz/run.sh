#!/bin/bash

set -x verbose
rm -rfv run

pc_align --max-displacement 100 ../data/ref-mars-PC.tif ../data/ref-mars_yxz.csv  --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --datum D_MARS --csv-format "3:z 2:x 1:y"








