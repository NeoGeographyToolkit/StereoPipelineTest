#!/bin/bash

set -x verbose
rm -rfv run

# Test orbit_plot. Make the result go to file.
~/miniconda3/envs/orbit_plot/bin/python $(which orbit_plot.py) --subtract-line-fit --dataset ../data/orbit_plot/ --orbit-id c1,c4 --dataset-label orbit_plot --output-file run/run.png
