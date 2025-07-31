#!/bin/bash

set -x verbose
rm -rfv run

# Grid a dataset having x, y, z values in a small ground-level box, as obtained from a 3D scanner
proj="+proj=stere +lat_0=0 +lat_ts=0 +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=1737400 +b=1737400 +units=m +no_defs"

point2dem --t_srs "$proj" --tr 1 --input-is-projected ../data/moon-PC.tif -o run/run

# TODO(oalexan1): Why does this fail after upgrading GDAP for ASP 3.5.0? There's no good reason.
# point2dem --t_srs "$proj" --tr 0.01 --input-is-projected ../data/scan.tif -o run/run

