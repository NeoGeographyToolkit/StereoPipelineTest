#!/bin/bash

set -x verbose
rm -rfv run

point2mesh ../data/point2mesh-PC.tif ../data/point2mesh-L.tif --output-prefix run/run
