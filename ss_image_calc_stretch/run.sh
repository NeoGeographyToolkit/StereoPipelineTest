#!/bin/bash

set -x verbose
rm -rfv run

image_calc --stretch ../data/filled_dem.tif -o run/run.tif

