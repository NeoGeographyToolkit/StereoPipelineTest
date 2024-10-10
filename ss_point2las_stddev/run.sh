#!/bin/bash

set -x verbose
rm -rfv run

point2las --save-stddev ../data/pc-stddev.tif --output-prefix run/run-LAS

