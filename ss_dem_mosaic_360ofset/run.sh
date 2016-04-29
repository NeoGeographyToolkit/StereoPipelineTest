#!/bin/bash

set -x verbose
rm -rfv run

dem_mosaic ../data/dem_clip7.tif ../data/dem_clip8.tif -o run/run

