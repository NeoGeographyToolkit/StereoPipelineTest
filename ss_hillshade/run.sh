#!/bin/bash

set -x verbose
rm -rfv run

hillshade --cog ../data/dem1_10pct.tif  -o run/run-hillshade.tif

