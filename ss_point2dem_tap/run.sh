#!/bin/bash

set -x verbose
rm -rfv run

point2dem --gdal-tap --tr 10 --t_projwin -191775 -2265255.2 -190865 -2266205.3 ../data/alaska-PC.tif -o run/run

