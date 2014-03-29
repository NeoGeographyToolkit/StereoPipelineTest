#!/bin/bash

set -x verbose
rm -rfv run

pc_align --max-displacement 100 ../data/ref-mars-PC.tif ../data/ref-mars-PC_trans.tif  --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run

