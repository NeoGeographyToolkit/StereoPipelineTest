#!/bin/bash

set -x verbose
rm -rfv run

echo ../data/dem1_10pct.tif > list.txt
echo ../data/dem2_10pct.tif >> list.txt

dem_mosaic -l list.txt -o run/run --extra-crop-length 200 --erode-length 1  --t_projwin 123.62 -14.26 133.03 -24.18 --tr 0.01  --hole-fill-len 200

