#!/bin/bash

set -x verbose
rm -rfv run

# Localhost does not work. Use actual machine name.
uname -n > machines.txt

mapproject --mpp 10 ../data/ref-DEM-unitDeg.tif ../data/WV01_11JAN131652275-P1BS-10200100104A0300.tif ../data/WV01_11JAN131652275-P1BS-10200100104A0300.xml run/run-RPC.tif -t dg --tile-size 512 --nodes-list machines.txt

