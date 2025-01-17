#!/bin/bash

set -x verbose
rm -rfv run

mapproject --tr 100 ../data/ctx_mapproj_bug_dem.tif ../data/ctx_mapproj_bug.cub run/run.tif --tile-size 300
