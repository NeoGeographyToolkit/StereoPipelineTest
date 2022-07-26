#!/bin/bash

set -x verbose
rm -rfv run

# Test reusing match files
bundle_adjust ../data/M0100115.cub ../data/E0201461.cub --num-iterations 2 -o run/ba1/run

bundle_adjust ../data/M0100115.cub ../data/E0201461.cub --num-iterations 2 -o run/ba2/run --clean-match-files-prefix run/ba1/run

stereo --match-files-prefix run/ba1/run ../data/M0100115.cub ../data/E0201461.cub run/run --alignment-method homography --stop-point 1 # want to test only loading of match file

