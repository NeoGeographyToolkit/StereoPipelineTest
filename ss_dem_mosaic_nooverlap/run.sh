#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

echo  ../data/dem_clip3.tif >  run/list.txt
echo  ../data/dem_clip4.tif >> run/list.txt

dem_mosaic -l run/list.txt -o run/run

