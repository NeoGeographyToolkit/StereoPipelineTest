#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

cam_test --session1 dg --session2 dg --image ../data/WV01_11JAN131652275-P1BS-10200100104A0300.tif --cam1 ../data/WV01_11JAN131652275-P1BS-10200100104A0300.xml --cam2 ../data/WV01_11JAN131652275-P1BS-10200100104A0300.xml | grep -E "Min|Max|Median" > run/run-out.txt

