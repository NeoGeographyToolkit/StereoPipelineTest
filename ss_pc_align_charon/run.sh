#!/bin/bash

set -x verbose
rm -rfv run

pc_align --max-displacement 20000 ../data/cpdem1.cub ../data/cpdem2.cub -o run/run --save-transformed-source-points --save-inv-transformed-reference-points 


