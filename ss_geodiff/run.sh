#!/bin/bash

set -x verbose
rm -rfv run

geodiff ../data/dem1_10pct.tif ../data/dem2_10pct.tif -o run/run


