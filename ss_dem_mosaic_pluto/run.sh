#!/bin/bash

set -x verbose
rm -rfv run

dem_mosaic ../data/dem_clip5.tif ../data/dem_clip6.tif -o run/run

