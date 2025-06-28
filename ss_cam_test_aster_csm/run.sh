#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

cam_test --image ../data/aster-Band3N.tif --cam1 ../data/aster-Band3N.xml --cam2 ../data/aster-Band3N.xml --aster-use-csm | grep -E "Min|Max|Median" > run/run-out.txt

