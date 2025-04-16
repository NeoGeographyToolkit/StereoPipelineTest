#!/bin/bash

set -x verbose
rm -rfv run

dem_geoid ../data/gggrx_1200b_meDE430_L002_L900_16ppd.tif --geoid-path ../data/gggrx_1200b_meDE430_L002_L900_16ppd.tif -o run/run

