#!/bin/bash

set -x verbose
rm -rfv run

pc_align --max-displacement 100 ../data/H2145_0000_DT4_crop.cub ../data/H2145_0000_DT4_crop.cub --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --datum D_MARS --max-num-source-points 100000 --max-num-reference-points 100000

