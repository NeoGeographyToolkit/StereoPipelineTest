#!/bin/bash

set -x verbose
rm -rfv run

uname -n >  machines.txt

parallel_bundle_adjust --processes 1 --threads 1 --nodes-list machines.txt  ../data/M0100115_small.cub ../data/E0201461_small.cub -o run/run --num-iterations 5 --ip-per-tile 1000
