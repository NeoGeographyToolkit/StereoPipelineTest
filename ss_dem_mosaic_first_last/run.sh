#!/bin/bash

set -x verbose
rm -rfv run

echo ../data/dem1_10pct.tif > list.txt
echo ../data/dem2_10pct.tif >> list.txt

for f in "" first last min max mean stddev median count; do 
	 
  opt=""
  if [ "$f" != "" ]; then 
    opt="--$f";
  fi

  dem_mosaic ../data/dem_clip1.tif ../data/dem_clip2.tif -o run/run $opt
done

