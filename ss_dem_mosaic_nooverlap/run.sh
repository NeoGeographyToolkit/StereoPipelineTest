#!/bin/bash

set -x verbose
rm -rfv run

echo  ../data/dem_clip3.tif >  list.txt
echo  ../data/dem_clip4.tif >> list.txt

dem_mosaic -l list.txt -o run/run 

