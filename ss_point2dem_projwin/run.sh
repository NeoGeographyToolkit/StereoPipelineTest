#!/bin/bash

set -x verbose
rm -rfv run

point2dem --tr 10 --t_projwin -191775 -2265255 -190865 -2266205 ../data/alaska-PC.tif -o run/run
