#!/bin/bash

set -x verbose
rm -rfv run

mkdir -p run
echo ../data/dem1_10pct.tif > run/list.txt
echo ../data/dem2_10pct.tif >> run/list.txt

for f in "" first last min max mean stddev median count block-max; do

  opt=""
  if [ "$f" != "" ]; then
    opt="--$f";
  fi

  dem_mosaic ../data/dem_clip1.tif ../data/dem_clip2.tif -o run/run $opt

  if [ "$f" = "" ] || [ "$f" == "first" ] || [ "$f" == "last" ] || \
	  [ "$f" == "min" ] || [ "$f" == "max" ];  then
  	for j in 0 1; do
	   dem_mosaic ../data/dem_clip1.tif ../data/dem_clip2.tif -o run/run $opt --save-dem-weight $j
	 done
  fi

done

