#!/bin/bash

set -x verbose
rm -rfv run

mkdir -p run
echo ../data/dem1_10pct.tif > run/list.txt
echo ../data/dem2_10pct.tif >> run/list.txt

image_subset --image-list run/list.txt -o run/subset.txt --threshold 0.001  
