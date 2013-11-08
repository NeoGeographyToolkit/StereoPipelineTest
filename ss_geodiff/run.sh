#!/bin/bash

set -x verbose
rm -rfv run

geodiff ../data/run-fsaa3-DEM.tif ../data/run-fsaa1-DEM.tif --absolute --output-prefix run/run



