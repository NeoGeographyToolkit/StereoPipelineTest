#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

f=../data/B17_016219_1978_XN_17N282W.8bit.cub
g=${f/.cub/.json}
cam_test --sample-rate 500 --image $f --cam1 $f --cam2 $g | grep -E "Min|Max|Median" > run/run-out.txt

