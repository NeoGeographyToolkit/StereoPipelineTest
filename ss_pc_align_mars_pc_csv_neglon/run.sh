#!/bin/bash

set -x verbose
rm -rfv run

pc_align --csv-format 1:lat,2:lon,3:height_above_datum --max-displacement 100 ../data/ref-mars-PC.tif ../data/ref-mars_neglon.csv  --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --datum D_MARS


