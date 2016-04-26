#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

# Bug based on Basalt Hills data. The cam box was 5x larger than necessary.

opt='+proj=utm +zone=10 +datum=WGS84 +units=m +no_defs '
mapproject --mpp 2 ../data/filled_dem.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001.xml -t rpc  --t_srs "$opt" run/run.tif

