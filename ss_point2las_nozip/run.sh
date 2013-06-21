#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

point2las $d/ref-PC.tif --output-prefix run/run-LAS

