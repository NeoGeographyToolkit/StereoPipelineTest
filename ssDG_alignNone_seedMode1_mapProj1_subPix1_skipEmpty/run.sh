#!/bin/bash

# Test skipping empty tiles based on D_sub

set -x verbose
rm -rfv run

# Set 0 as nodata
image_calc -c "var_0" -d float32 --output-nodata-value 0            \
  ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_rpc_5mpp.tif \
  -o run/left.tif
image_calc -c "var_0" -d float32 --output-nodata-value 0            \
  ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_rpc_5mpp.tif \
  -o run/right.tif

# Make a lot of the images be no-data
gdal_rasterize -i -burn 0                                           \
  ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_rpc_5mpp.shp \
  run/left.tif
gdal_rasterize -i -burn 0                                           \
  ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_rpc_5mpp.shp \
  run/right.tif

parallel_stereo                                                \
  --job-size-w 1024 --job-size-h 1024                          \
  run/left.tif                                                 \
  run/right.tif                                                \
  ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_rpc.xml \
  ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_rpc.xml \
  run/run                                                      \
  ../data/zone10-CA_SanLuisResevoir-9m.tif

point2dem -r Earth run/run-PC.tif 
