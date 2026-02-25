#!/bin/bash

# TODO(oalexan1): Enable --nearest-neighbor and update gold on lunokhod1.
# This gives nearest-neighbor coverage that no other mapproject test has.

set -x verbose
rm -rfv run

mapproject ../data/srtm_59_08.tif ../data/mapprojtest.tif ../data/mapprojtest.xml run/run-RPC.tif --t_srs "+proj=eqc +units=m +datum=WGS84" --tr 0.5 -t rpc
#mapproject ../data/srtm_59_08.tif ../data/mapprojtest.tif ../data/mapprojtest.xml run/run-RPC.tif --t_srs "+proj=eqc +units=m +datum=WGS84" --tr 0.5 -t rpc --nearest-neighbor

