#!/bin/bash

d=../data
dir=run
rm -rfv $dir
mkdir -p $dir

point2las $d/ref-PC.tif --output-prefix run/run-LAS

