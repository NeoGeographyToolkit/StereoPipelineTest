#!/bin/bash

set -x verbose
rm -rfv run

mapproject ../data/srtm_59_08.tif ../data/mapprojtest.tif ../data/mapprojtest.xml run/run-RPC.tif --t_srs "+proj=eqc +units=m +datum=WGS84" --tr 0.5 -t rpc --gdal-tap --t_projwin 12610941.000 2579715.000 12611485.000 2580214.500 --cog

