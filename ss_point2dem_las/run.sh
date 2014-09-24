#!/bin/bash

set -x verbose
rm -rfv run

point2dem -r Earth --tr 0.000012676199264 ../data/stadium-utm.laz -o run/run --nodata-value -32767

