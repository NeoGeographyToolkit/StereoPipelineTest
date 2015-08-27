#!/bin/bash

set -x verbose
rm -rfv run
mkdir run

/byss/smcmich1/repo/StereoPipeline/src/asp/Tools/pc_merge ../data/ref-mars-crop1-PC.tif ../data/ref-mars-crop2-PC.tif -o run/run-PC.tif
point2dem -r mars run/run-PC.tif --nodata-value -32768 


