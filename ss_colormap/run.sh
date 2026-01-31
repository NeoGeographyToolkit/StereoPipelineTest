#!/bin/bash

set -x verbose
rm -rfv run

colormap --cog --hillshade ../data/dem1_10pct.tif  -o run/run-colormap.tif

