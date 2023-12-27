#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

# The second cub file has a CSM camera model state emebedded in it

cam_test --sample-rate 500 --image ../data/B17_016219_1978_XN_17N282W.8bit.cub --cam1 ../data/B17_016219_1978_XN_17N282W.8bit.cub --cam2 ../data/B17_016219_1978_XN_17N282W.csm.cub --session1 isis --session2 csm | grep -E "Min|Max|Median" > run/run-out.txt
