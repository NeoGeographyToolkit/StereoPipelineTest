#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust ../data/AS15-M-1134.lev1.cub ../data/AS15-M-1135.lev1.cub --cost-function cauchy --robust-threshold 0.5 --max-iterations 100 -o run/run --threads 1


