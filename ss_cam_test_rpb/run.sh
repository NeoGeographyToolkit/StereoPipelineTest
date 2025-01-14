#!/bin/bash

set -x verbose
rm -rfv run

# Test an RPB file

mkdir run

cam_test --image ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.tif --cam1 ../data/camera.rpb --cam2 ../data/camera.rpb --session1 rpc --session2 rpc | grep -E "Min|Max|Median" > run/run-out.txt

