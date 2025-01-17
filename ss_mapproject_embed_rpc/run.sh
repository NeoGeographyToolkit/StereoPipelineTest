#!/bin/bash

set -x verbose
rm -rfv run

# Test the --query-pixel option
mkdir -p run 
mapproject ../data/Copernicus_DSM.tif ../data/basic_panchromatic.tif run/run-RPC.tif --query-pixel 677 333 | grep -i -v gdal | tee run/run-query.txt

# Test mapprojection with embeded camera
mapproject ../data/Copernicus_DSM.tif ../data/basic_panchromatic.tif run/run-RPC.tif
