#!/bin/bash

set -x verbose
rm -rfv run

point2las --triangulation-error-factor 255 ../data/ref-PC.tif --output-prefix run/run-LAS -r Earth

