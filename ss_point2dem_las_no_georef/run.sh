#!/bin/bash

set -x verbose
rm -rfv run

point2dem -r Earth --tr 1 ../data/ref-PC.las -o run/run --nodata-value -32767

