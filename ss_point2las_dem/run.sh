#!/bin/bash

set -x verbose
rm -rfv run

point2las --dem ../data/ref-DEM.tif --output-prefix run/run-LAS

