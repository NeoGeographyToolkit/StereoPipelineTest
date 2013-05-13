#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

dem_geoid $d/mars.tif -o run/run --double

