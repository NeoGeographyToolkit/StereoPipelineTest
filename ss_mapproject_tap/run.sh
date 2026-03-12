#!/bin/bash

set -x verbose
rm -rfv run

mapproject ../data/srtm_59_08.tif ../data/mapprojtest.tif ../data/mapprojtest.xml run/run-RPC.tif --t_srs "+proj=eqc +units=m +datum=WGS84" --tr 0.5 -t rpc --gdal-tap --t_projwin 12610941.000 2579715.000 12611485.000 2580214.500 --cog

# Test uint8 input with --ot Byte output to verify pixel values are preserved
# (input mapprojtest.tif is uint8 with values 38-73)
mapproject ../data/srtm_59_08.tif ../data/mapprojtest.tif ../data/mapprojtest.xml run/run-RPC-Byte.tif --t_srs "+proj=eqc +units=m +datum=WGS84" --tr 0.5 -t rpc --gdal-tap --t_projwin 12610941.000 2579715.000 12611485.000 2580214.500 --ot Byte

