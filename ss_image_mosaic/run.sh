#!/bin/bash

set -x verbose
rm -rfv run

image_mosaic ../data/DZB00402500038H012001_12_c_sub16.tif ../data/DZB00402500038H012001_12_b_sub16.tif --ot byte --blend-radius 2000 --overlap-width 20000 --cache-size 10000 --cog -o run/run.tif
