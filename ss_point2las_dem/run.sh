#!/bin/bash

set -x verbose
rm -rfv run

point2las --dem  ../data/filled_dem_25pct.tif --output-prefix run/run-LAS

