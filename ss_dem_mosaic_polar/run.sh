#!/bin/bash

set -x verbose
rm -rfv run

dem_mosaic ../data/krigged_part1.tif ../data/krigged_part2.tif -o run/run

