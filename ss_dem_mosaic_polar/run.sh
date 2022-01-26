#!/bin/bash

set -x verbose
rm -rfv run

dem_mosaic --tr 10000.0 --tap ../data/krigged_part1.tif ../data/krigged_part2.tif -o run/run

