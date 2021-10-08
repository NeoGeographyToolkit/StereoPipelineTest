#!/bin/bash

set -x verbose
rm -rfv run

uname -n >  machines.txt

parallel_bundle_adjust --processes 2 --threads 8 --nodes-list machines.txt  ../data/M0100115_small.cub ../data/E0201461_small.cub -o run/run
