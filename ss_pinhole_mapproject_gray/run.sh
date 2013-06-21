#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

mapproject --mpp 300 $d/ssPinHole-ref-DEM.tif $d/ssPinHole-ref-Gray.tif $d/1n270487304eff90cip1952l0m1.cahvor run/run-ortho.tif




