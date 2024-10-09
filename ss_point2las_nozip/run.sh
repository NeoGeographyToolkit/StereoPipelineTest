#!/bin/bash

set -x verbose
rm -rfv run

point2las --save-triangulation-error\
  ../data/ref-PC.tif \
  --save-intensity-from-image ../data/ref-L.tif \
  --output-prefix run/run-LAS -r Earth

