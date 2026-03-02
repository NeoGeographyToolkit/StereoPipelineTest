#!/bin/bash

set -x verbose
rm -rfv run

# Use --nearest-neighbor for test coverage (no other mapproject test has this)
mapproject ../data/srtm_59_08.tif ../data/mapprojtest.tif ../data/mapprojtest.xml run/run-RPC.tif --t_srs "+proj=eqc +units=m +datum=WGS84" --tr 0.5 -t rpc --nearest-neighbor

