#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/basalt-DEM1.tif ../data/basalt-DEM2.tif -o run/run --max-displacement 100 --max-horizontal-offset 100 --max-vertical-offset 100 --save-transformed-source-points --save-inv-transformed-reference-points


