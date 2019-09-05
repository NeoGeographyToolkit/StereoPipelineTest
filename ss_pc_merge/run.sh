#!/bin/bash

set -x verbose
rm -rfv run

pc_merge ../data/ref-mars-crop1-PC.tif ../data/ref-mars-crop2-PC.tif -o run/run-merge-PC.tif

pc_merge ../data/ref-mars-crop1-L.tif ../data/ref-mars-crop2-L.tif -o run/run-merge-L.tif

point2dem -r mars run/run-merge-PC.tif --nodata-value -32768 --orthoimage run/run-merge-L.tif


