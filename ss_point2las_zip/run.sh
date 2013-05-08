#!/bin/bash

d=../data
dir=run
rm -rfv $dir
mkdir -p $dir

point2las --compressed $d/ref-PC.tif --output-prefix run/run-LAS

