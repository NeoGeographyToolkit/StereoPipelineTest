#!/bin/bash

set -x verbose
rm -rfv run

point2dem --tr 10 --gdal-tap ../data/alaska-PC.tif -o run/run

