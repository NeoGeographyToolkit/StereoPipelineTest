#!/bin/bash

set -x verbose
rm -rfv run

# These dems are offset by 360 degrees in longitude and they overlap only partially.
# There were bugfixes in both of these cases.
geodiff ../data/dem3.tif ../data/dem4.tif -o run/run

