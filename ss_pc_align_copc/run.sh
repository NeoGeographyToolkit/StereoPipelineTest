#!/bin/bash

set -x verbose
rm -rfv run

pc_align ../data/autzen-classified.copc.laz ../data/autzen-classified.copc.laz --max-displacement 100 --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --csv-format utm:10N,1:easting,2:northing,3:height_above_datum --ref-copc-win 636400 852260 638180 849990 --src-copc-win 636400 852260 638180 849990

