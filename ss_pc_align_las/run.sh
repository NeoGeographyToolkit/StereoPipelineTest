#!/bin/bash

set -x verbose
rm -rfv run

machine=$(uname -n | grep centos-32-5)
if [ "$machine" !=  "" ]; then 
 opt="--max-num-reference-points 1000000" # to avoid running out of memory
fi

pc_align ../data/stadium-utm.laz ../data/stadium-utm.csv --max-displacement 100 --save-transformed-source-points --save-inv-transformed-reference-points --output-prefix run/run --csv-format 'utm:10N 1:easting 2:northing 3:height_above_datum' $opt

