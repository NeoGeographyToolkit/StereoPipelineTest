#!/bin/bash

set -x verbose
rm -rfv run

mapproject --mpp 300 ../data/ssPinHole-ref-DEM.tif ../data/ssPinHole-ref-Gray.tif ../data/1n270487304eff90cip1952l0m1.cahvor run/run-ortho.tif




