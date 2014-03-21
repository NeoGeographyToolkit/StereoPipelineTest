#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10_proj.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10_proj.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.xml ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.xml run/run ../data/basalt_dem_crop.tif --alignment-method none --left-image-crop-win 1024 1024 2048 1024

point2dem -r Earth run/run-PC.tif --nodata-value -32767
