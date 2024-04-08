#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Test AdjutableTsai
bundle_adjust ../data/left_sub16.tif ../data/right_sub16.tif ../data/left_sub16.adj.tsai ../data/right_sub16.adj.tsai --inline-adjustments -t pinhole --datum WGS84 -o run/run --threads 1 

