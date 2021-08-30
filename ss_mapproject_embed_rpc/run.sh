#!/bin/bash

set -x verbose
rm -rfv run

mapproject ../data/Copernicus_DSM.tif ../data/basic_panchromatic.tif run/run-RPC.tif
