#!/bin/bash

set -x verbose
rm -rfv run

point2mesh ../data/run-PC.tif ../data/run-L.tif -l --output-prefix run/run


