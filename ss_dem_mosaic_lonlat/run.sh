#!/bin/bash

set -x verbose
rm -rfv run

echo ../data/dem1_10pct.tif > list.txt
echo ../data/dem2_10pct.tif >> list.txt

dem_mosaic -l list.txt -o run/run --blending-len 200 --erode-len 1

