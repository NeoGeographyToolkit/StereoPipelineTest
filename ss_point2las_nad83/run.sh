#!/bin/bash

set -x verbose
rm -rfv run

point2las ../data/ref-PC.tif --output-prefix run/run-LAS --t_srs '+proj=utm +zone=10 +datum=NAD83 +units=m +no_defs '

